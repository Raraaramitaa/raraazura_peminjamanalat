import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman lain (Pastikan file ini ada di project Anda)
import 'tambah_alat.dart';
import 'edit_alat.dart';
import 'hapus_pengguna.dart'; // Berisi HapusAlatDialog

import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
// ignore: unused_import
import 'package:peminjam_alat/admin/logout.dart';
// Perbaikan: Gunakan 'as' jika nama class KategoriPage bentrok
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

// Placeholder untuk halaman yang belum ada
class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Halaman Kategori")));
}

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text("Halaman Peminjaman")));
}

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

  @override
  void initState() {
    super.initState();
    fetchAlat();
    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredAlatList = List.from(alatList);
      } else {
        filteredAlatList = alatList.where((alat) {
          final namaAlat = (alat['nama_alat'] ?? '').toString().toLowerCase();
          return namaAlat.contains(query);
        }).toList();
      }
    });
  }

  Future<void> fetchAlat() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('alat')
          .select()
          .order('id_alat', ascending: true);

      if (mounted) {
        setState(() {
          alatList = List<Map<String, dynamic>>.from(data as List);
          filteredAlatList = List<Map<String, dynamic>>.from(alatList);
          if (_searchController.text.isNotEmpty) {
            _onSearchChanged();
          }
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("ERROR FETCH ALAT: $e");
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
    }
  }

  Future<void> hapusAlat(int id) async {
    try {
      await supabase.from('alat').delete().eq('id_alat', id);
      if (mounted) {
        fetchAlat();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Alat berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal menghapus: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onNavTapped(int index) {
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
          // ===== HEADER =====
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
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                
                // ===== SEARCH BAR =====
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Cari Barang...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF8FAFB6)),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ===== FILTER KATEGORI =====
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterIcon("Laptop", Icons.laptop_mac),
                _buildFilterIcon("Proyektor", Icons.videocam_outlined),
                _buildFilterIcon("Camera", Icons.camera_alt_outlined),
                _buildFilterIcon("Mouse", Icons.mouse_outlined),
              ],
            ),
          ),
          const Divider(thickness: 1),

          // ===== GRID LIST ALAT =====
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF8FAFB6)))
                : filteredAlatList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 60, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              "Alat '${_searchController.text}' tidak ditemukan",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        itemCount: filteredAlatList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) =>
                            _buildItemCard(filteredAlatList[index]),
                      ),
          ),
        ],
      ),

      // ===== FLOATING BUTTON TAMBAH =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahAlatPage()),
          ).then((_) => fetchAlat());
        },
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),

      // ===== BOTTOM NAVBAR (DISESUIAKAN DENGAN DASHBOARD ADMIN) =====
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
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
      ),
    );
  }

  // ================= WIDGET ITEM CARD =================
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image, size: 45, color: Colors.grey),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item['nama_alat'] ?? "Tanpa Nama",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditAlatPage(data: item)),
                ).then((_) => fetchAlat());
              },
              child: const Icon(Icons.edit, size: 18, color: Colors.blueGrey),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => HapusAlatDialog(
                    onConfirm: () => hapusAlat(item['id_alat']),
                  ),
                );
              },
              child: const Icon(Icons.delete_outline,
                  size: 18, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterIcon(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF8FAFB6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
