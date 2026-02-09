// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tambah_alat.dart';
import 'edit_alat.dart';

import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

// =========================================================
// DIALOG HAPUS
// =========================================================
class HapusAlatDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const HapusAlatDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Hapus Alat"),
      content: const Text("Apakah Anda yakin ingin menghapus alat ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text(
            "Hapus",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

// =========================================================
// HALAMAN RIWAYAT / PEMINJAMAN (SATU SAJA)
// =========================================================
class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Halaman Riwayat Peminjaman")),
    );
  }
}

// =========================================================
// HALAMAN ALAT
// =========================================================
class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> alatList = [];
  List<Map<String, dynamic>> filteredAlatList = [];

  bool isLoading = true;
  final int _currentIndex = 2;

  final TextEditingController _searchController = TextEditingController();
  String _selectedKategori = "Semua";

  @override
  void initState() {
    super.initState();
    fetchAlat();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // FETCH & FILTER
  // =========================================================
  Future<void> fetchAlat() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('alat')
          .select()
          .order('id_alat', ascending: true);

      alatList = List<Map<String, dynamic>>.from(data as List);
      _applyFilters();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e")),
      );
    }
    setState(() => isLoading = false);
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredAlatList = alatList.where((alat) {
        final nama = (alat['nama_alat'] ?? '').toString().toLowerCase();
        final kategori = (alat['kategori'] ?? '').toString();

        return nama.contains(query) &&
            (_selectedKategori == "Semua" ||
                kategori == _selectedKategori);
      }).toList();
    });
  }

  Future<void> hapusAlat(int id) async {
    await supabase.from('alat').delete().eq('id_alat', id);
    fetchAlat();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Alat berhasil dihapus"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // =========================================================
  // NAVBAR
  // =========================================================
  void _onNavTapped(int index) {
    if (index == _currentIndex) return;

    Widget page;
    switch (index) {
      case 0:
        page = const DashboardAdminPage();
        break;
      case 1:
        page = const PenggunaPage();
        break;
      case 2:
        page = const AlatPage();
        break;
      case 3:
        page = const kat.KategoriPage();
        break;
      case 4:
        page = const PeminjamanPage();
        break;
      case 5:
        page = const LogoutPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // =========================================================
  // UI
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                const Text("Admin",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(height: 6),
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white54,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Rara Aramita Azura",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                // SEARCH
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Cari Alat...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // FILTER KATEGORI
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterIcon("Semua", Icons.grid_view, "Semua"),
                  _filterIcon("Laptop", Icons.laptop, "Laptop"),
                  _filterIcon("Proyektor", Icons.videocam, "Proyektor"),
                  _filterIcon("Camera", Icons.camera_alt, "Camera"),
                  _filterIcon("Mouse", Icons.mouse, "Mouse"),
                ],
              ),
            ),
          ),

          const Divider(),

          // GRID
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredAlatList.isEmpty
                    ? _emptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: filteredAlatList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (_, i) =>
                            _alatCard(filteredAlatList[i]),
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TambahAlatPage(imageFile: null),
            ),
          );
          fetchAlat();
        },
        child: const Icon(Icons.add),
      ),

      // NAVBAR ADMIN (SAMA DENGAN DASHBOARD)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        backgroundColor: const Color(0xFF8FAFB6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
        ],
      ),
    );
  }

  // =========================================================
  // WIDGET BANTUAN
  // =========================================================
  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search_off, size: 80, color: Colors.grey),
        SizedBox(height: 10),
        Text("Alat tidak ditemukan"),
      ],
    );
  }

  Widget _filterIcon(String label, IconData icon, String key) {
    final selected = _selectedKategori == key;
    return GestureDetector(
      onTap: () {
        _selectedKategori = key;
        _applyFilters();
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF4A6A70)
                    : const Color(0xFF8FAFB6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _alatCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: item['foto_url'] != null
                    ? Image.network(item['foto_url'], fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 40),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Text(
                  item['nama_alat'] ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAlatPage(data: item),
                  ),
                );
                fetchAlat();
              },
              child: const CircleAvatar(
                radius: 12,
                child: Icon(Icons.edit, size: 14),
              ),
            ),
          ),
          Positioned(
            top: 6,
            left: 6,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => HapusAlatDialog(
                    onConfirm: () => hapusAlat(item['id_alat']),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.redAccent,
                child:
                    Icon(Icons.delete, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
