// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'tambah_alat.dart';
import 'edit_alat.dart';
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

// =========================================================
// 1. WIDGET DIALOG HAPUS
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
          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

// =========================================================
// 2. PLACEHOLDER HALAMAN PEMINJAMAN
// =========================================================
class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Halaman Peminjaman")));
}

// =========================================================
// 3. MAIN PAGE: ALAT PAGE
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
    _searchController.addListener(() {
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredAlatList = alatList.where((alat) {
        final namaAlat = (alat['nama_alat'] ?? '').toString().toLowerCase();
        final kategoriAlat = (alat['kategori'] ?? '').toString();
        bool matchesSearch = namaAlat.contains(query);
        bool matchesKategori =
            (_selectedKategori == "Semua") || (kategoriAlat == _selectedKategori);
        return matchesSearch && matchesKategori;
      }).toList();
    });
  }

  Future<void> fetchAlat() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final data =
          await supabase.from('alat').select().order('id_alat', ascending: true);
      if (mounted) {
        setState(() {
          alatList = List<Map<String, dynamic>>.from(data as List);
          _applyFilters();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR FETCH ALAT: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
      }
    }
  }

  Future<void> hapusAlat(dynamic id) async {
    try {
      await supabase.from('alat').delete().eq('id_alat', id);
      if (mounted) {
        fetchAlat();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Alat berhasil dihapus"),
          backgroundColor: Colors.green,
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Gagal menghapus: $e"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _navigateToTambahAlat() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TambahAlatPage(imageFile: null)),
    );
    fetchAlat();
  }

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
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

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
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 5),
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white54,
                  child: Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Rara Aramita Azura",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
                const SizedBox(height: 20),
                // BAR PENCARIAN
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "Cari Barang...",
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF8FAFB6)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // AREA FILTER KATEGORI
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterIcon("Semua", Icons.grid_view, "Semua"),
                  _buildFilterIcon("Laptop", Icons.laptop_mac, "Laptop"),
                  _buildFilterIcon("Proyektor", Icons.videocam_outlined, "Proyektor"),
                  _buildFilterIcon("Camera", Icons.camera_alt_outlined, "Camera"),
                  _buildFilterIcon("Mouse", Icons.mouse_outlined, "Mouse"),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, height: 1),

          // AREA DAFTAR BARANG
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF8FAFB6)))
                : filteredAlatList.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: filteredAlatList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.70,
                        ),
                        itemBuilder: (context, index) =>
                            _buildItemCard(filteredAlatList[index]),
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: _navigateToTambahAlat,
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF8FAFB6),
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_return_outlined), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          Text("Alat tidak ditemukan", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    String? imageUrl = item['foto_url']?.toString();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              // AREA FOTO
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15)),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image,
                                    size: 40, color: Colors.grey),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        )
                      : const Center(
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                ),
              ),
              // NAMA ALAT
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Text(
                  item['nama_alat'] ?? "Tanpa Nama",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              // LABEL STATUS
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8FAFB6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item['status'] ?? "Ada",
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
          // TOMBOL EDIT
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditAlatPage(data: item)),
                ).then((_) => fetchAlat());
              },
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white70,
                child: Icon(Icons.edit, size: 14, color: Colors.blueGrey),
              ),
            ),
          ),
          // TOMBOL HAPUS
          Positioned(
            top: 5,
            left: 5,
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
                backgroundColor: Colors.white70,
                child:
                    Icon(Icons.delete_outline, size: 14, color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(String label, IconData icon, String kategoriKey) {
    bool isSelected = _selectedKategori == kategoriKey;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKategori = kategoriKey;
          _applyFilters();
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF4A6A70) : const Color(0xFF8FAFB6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
