// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- IMPORT FILE PENDUKUNG ---
import 'tambah_alat.dart';
import 'edit_alat.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/kategori/kategori.dart' as kat;
import 'package:peminjam_alat/riwayat/riwayat.dart';

// =========================================================
// DIALOG KONFIRMASI HAPUS
// =========================================================
class HapusAlatDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  const HapusAlatDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Hapus Alat", style: TextStyle(fontWeight: FontWeight.bold)),
      content: const Text("Apakah Anda yakin ingin menghapus alat ini?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Navigator.pop(context); 
            onConfirm(); 
          },
          child: const Text("Hapus", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// =========================================================
// HALAMAN UTAMA ALAT
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
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAlat());
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- LOGIKA AMBIL DATA ---
  Future<void> fetchAlat() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final data = await supabase
          .from('alat')
          .select()
          .order('id_alat', ascending: true);

      if (mounted) {
        setState(() {
          alatList = List<Map<String, dynamic>>.from(data);
          _applyFilters();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showToast("Gagal memuat data: $e", Colors.red);
      }
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredAlatList = alatList.where((alat) {
        final nama = (alat['nama_alat'] ?? '').toString().toLowerCase();
        final kategori = (alat['kategori'] ?? '').toString();

        final matchesSearch = nama.contains(query);
        final matchesKategori =
            (_selectedKategori == "Semua" || kategori == _selectedKategori);

        return matchesSearch && matchesKategori;
      }).toList();
    });
  }

  // --- FUNGSI HAPUS ALAT (DI-UPDATE) ---
  Future<void> hapusAlat(dynamic id) async {
    if (id == null) return;

    // Tampilkan Loading Indikator agar user tahu proses sedang berjalan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Eksekusi hapus di database Supabase
      // Gunakan eq('id_alat', id) dan pastikan ID yang dikirim benar
      await supabase
          .from('alat')
          .delete()
          .eq('id_alat', id);

      // 2. Tutup loading indikator
      if (mounted) Navigator.pop(context);

      // 3. Update list lokal hanya jika request ke server berhasil
      if (mounted) {
        setState(() {
          alatList.removeWhere((item) => item['id_alat'] == id);
          _applyFilters();
        });
        _showToast("Alat berhasil dihapus secara permanen", Colors.green);
      }
    } catch (e) {
      // Tutup loading jika error
      if (mounted) Navigator.pop(context);
      
      _showToast("Gagal menghapus! Pastikan alat tidak sedang dipinjam (Foreign Key Error).", Colors.red);
      debugPrint("Error hapus: $e");
    }
  }

  void _showToast(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // --- NAVIGASI ---
  void _onNavTapped(int index) {
    if (index == _currentIndex) return;
    Widget page;
    switch (index) {
      case 0: page = const DashboardAdminPage(); break;
      case 1: page = const PenggunaPage(); break;
      case 3: page = const kat.KategoriPage(); break;
      case 4: page = const RiwayatPage(); break;
      case 5: page = const LogoutPage(); break;
      default: return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          _buildKategoriFilter(),
          const Divider(height: 1),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF8FAFB6)))
                : RefreshIndicator(
                    onRefresh: fetchAlat,
                    child: filteredAlatList.isEmpty ? _emptyState() : _buildGrid(),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahAlatPage(imageFile: null)),
          );
          if (result == true) fetchAlat();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        backgroundColor: const Color(0xFF8FAFB6),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
          const Text("Admin", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          const CircleAvatar(
            radius: 26,
            backgroundColor: Colors.white54,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(height: 6),
          const Text("Rara Aramita Azura", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 15),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Cari Alat...",
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriFilter() {
    return Padding(
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
    );
  }

  Widget _filterIcon(String label, IconData icon, String key) {
    final bool isSelected = _selectedKategori == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKategori = key;
          _applyFilters();
        });
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4A6A70) : const Color(0xFF8FAFB6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: filteredAlatList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) => _alatCard(filteredAlatList[i]),
    );
  }

  Widget _alatCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: item['foto_url'] != null && item['foto_url'].toString().isNotEmpty
                      ? Image.network(
                          item['foto_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      : Container(color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  item['nama_alat'] ?? 'Tanpa Nama',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          // TOMBOL EDIT
          Positioned(
            top: 5,
            right: 5,
            child: InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditAlatPage(data: item)),
                );
                if (result == true) fetchAlat();
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.blue.withOpacity(0.9),
                child: const Icon(Icons.edit, size: 14, color: Colors.white),
              ),
            ),
          ),
          // TOMBOL DELETE
          Positioned(
            top: 5,
            left: 5,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => HapusAlatDialog(
                    onConfirm: () => hapusAlat(item['id_alat']),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.redAccent.withOpacity(0.9),
                child: const Icon(Icons.delete, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SizedBox(height: 100),
        Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 80, color: Colors.grey),
              SizedBox(height: 10),
              Text("Alat tidak ditemukan", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}