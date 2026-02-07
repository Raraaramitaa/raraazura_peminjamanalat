import 'package:flutter/material.dart';
import 'package:peminjam_alat/alat/hapus_pengguna.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ===== IMPORT HALAMAN ADMIN LAIN =====
// ignore: unused_import
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';

// ===== IMPORT FILE KOMPONEN FITUR =====
import 'edit_alat.dart';
import 'tambah_alat.dart';

// Placeholder untuk halaman yang belum ada agar tidak error saat navigasi
class KategoriPage extends StatelessWidget {
  const KategoriPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Halaman Kategori")));
}

class PeminjamanPage extends StatelessWidget {
  const PeminjamanPage({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Halaman Peminjaman")));
}

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Inisialisasi Supabase Client
  final SupabaseClient supabase = Supabase.instance.client;

  // State Management
  List<Map<String, dynamic>> alatList = [];
  bool isLoading = true;
  final int _currentIndex = 2; // Index aktif untuk menu "Produk"

  @override
  void initState() {
    super.initState();
    fetchAlat();
  }

  // ================= 1. FUNGSI AMBIL DATA (READ) =================
  Future<void> fetchAlat() async {
    setState(() => isLoading = true);
    try {
      final data = await supabase
          .from('alat')
          .select()
          .order('id_alat', ascending: true);

      setState(() {
        alatList = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetch alat: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
    }
  }

  // ================= 2. FUNGSI HAPUS DATA (DELETE) =================
  Future<void> prosesHapusAlat(int id) async {
    try {
      await supabase.from('alat').delete().eq('id_alat', id);
      
      if (mounted) {
        Navigator.pop(context); // Menutup dialog konfirmasi
        fetchAlat(); // Refresh data list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Barang berhasil dihapus"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ================= 3. LOGIKA NAVIGASI NAVBAR =================
  void _onNavTapped(int index) {
    if (index == _currentIndex) return;

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = const DashboardAdminPage() as Widget;
        break;
      case 1:
        targetPage = const PenggunaPage();
        break;
      case 2:
        targetPage = const AlatPage();
        break;
      case 3:
        targetPage = const KategoriPage();
        break;
      case 4:
        targetPage = const PeminjamanPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  // ================= 4. BUILDER UI UTAMA =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // --- BAGIAN HEADER (BIRU TEAL) ---
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
                const Text("Admin", style: TextStyle(color: Colors.white, fontSize: 14)),
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
                // Search Bar
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Cari Barang",
                      hintStyle: TextStyle(color: Colors.white70),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BAGIAN KATEGORI (FILTER) ---
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

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(thickness: 1),
          ),

          // --- BAGIAN GRID LIST BARANG ---
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF8FAFB6)))
                : alatList.isEmpty
                    ? const Center(child: Text("Data alat kosong"))
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        itemCount: alatList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final item = alatList[index];
                          return _buildItemCard(item);
                        },
                      ),
          ),
        ],
      ),

      // --- TOMBOL TAMBAH (FAB) ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahAlatPage()),
          ).then((_) => fetchAlat()); // Refresh data saat kembali
        },
        child: const Icon(Icons.add, color: Colors.black, size: 35),
      ),

      // --- NAVIGASI BAWAH ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Pinjam'),
        ],
      ),
    );
  }

  // ================= 5. WIDGET KOMPONEN KECIL =================

  // Widget Card untuk per Item
  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder Gambar
              const Center(child: Icon(Icons.image, size: 45, color: Colors.grey)),
              const SizedBox(height: 8),
              // Nama Barang
              Text(
                item['nama_alat'] ?? 'Tanpa Nama',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              // Label Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF8FAFB6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  item['status'] ?? 'Tersedia',
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
          // Tombol Edit (Kanan Atas)
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditAlatPage(data: item)),
                ).then((_) => fetchAlat());
              },
              child: const Icon(Icons.edit, size: 16, color: Colors.black54),
            ),
          ),
          // Tombol Hapus (Kanan Bawah)
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => HapusAlatDialog(
                    onConfirm: () => prosesHapusAlat(item['id_alat']),
                  ),
                );
              },
              child: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Icon Filter Kategori
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
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class DashboardAdminPage {
  const DashboardAdminPage();
}