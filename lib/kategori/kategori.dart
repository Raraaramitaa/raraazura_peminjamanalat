// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/kategori/tambah_kategori.dart';
import 'package:peminjam_alat/kategori/edit_kategori.dart';
// ignore: unused_import
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/alat/alat.dart';
// Aliasing untuk menghindari konflik nama class
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

// ================= MODEL LOKAL =================
class Kategori {
  final int id;
  String nama;
  String? gambarUrl;

  Kategori({required this.id, required this.nama, this.gambarUrl, String? gambarPath});

  String? get gambarPath => null;
}

// ================= PAGE =================
class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final supabase = Supabase.instance.client;

  List<Kategori> kategoriList = [];
  String searchQuery = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchKategori();
  }

  // ================= FETCH DATA =================
  Future<void> fetchKategori() async {
    setState(() => loading = true);
    try {
      final response = await supabase.from('kategori').select().order('id_kategori');
      final List data = response as List;
      setState(() {
        kategoriList = data.map((e) {
          return Kategori(
            id: e['id_kategori'],
            nama: e['nama_kategori'] ?? '',
            gambarUrl: e['gambar_url'],
          );
        }).toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      debugPrint('Error fetch kategori: $e');
    }
  }

  // ================= DELETE DATA =================
  Future<void> deleteKategori(int id) async {
    try {
      await supabase.from('kategori').delete().eq('id_kategori', id);
      fetchKategori();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil dihapus')),
      );
    } catch (e) {
      debugPrint('Error delete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = kategoriList
        .where((k) => k.nama.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),

      // ================= BODY =================
      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 15, right: 15),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Daftar Kategori',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // ================= SEARCH & ADD =================
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFFF0F0F0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari kategori alat...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Kategori'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8FAFB6),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const KategoriTambahPage(),
                        ),
                      );
                      if (result != null) fetchKategori();
                    },
                  ),
                ),
              ],
            ),
          ),

          // ================= LIST ITEMS =================
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                    ? const Center(child: Text('Kategori tidak ditemukan'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final kategori = filteredList[index];

                          // ===== Konversi ke kat.Kategori =====
                          final katKategori = kat.Kategori(
                            id: kategori.id,
                            nama: kategori.nama,
                            gambarPath: kategori.gambarUrl,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFB4C8CC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: [
                                // Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    image: kategori.gambarUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(kategori.gambarUrl!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: kategori.gambarUrl == null
                                      ? const Icon(Icons.image, size: 50, color: Colors.grey)
                                      : null,
                                ),
                                const SizedBox(width: 15),
                                // Nama kategori
                                Expanded(
                                  child: Text(
                                    kategori.nama,
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Buttons Edit & Hapus
                                Column(
                                  children: [
                                    _buildSmallButton('Edit', const Color(0xFF4A68FF), () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              KategoriEditPage(kategori: katKategori),
                                        ),
                                      ).then((_) => fetchKategori());
                                    }),
                                    const SizedBox(height: 8),
                                    _buildSmallButton(
                                      'Hapus',
                                      const Color(0xFFFF4A4A),
                                      () => _showDeleteDialog(kategori),
                                      isDelete: true,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),

      // ================= BOTTOM NAVIGATION BAR =================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF8FAFB6),
        currentIndex: 3,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => KatDashboard_AdminPage()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const PenggunaPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const AlatPage()));
          } else if (index == 5) {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LogoutPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
        ],
      ),
    );
  }

  // ================= HELPER: SHOW DELETE DIALOG =================
  void _showDeleteDialog(Kategori kategori) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kategori'),
          content: Text('Apakah Anda yakin ingin menghapus kategori "${kategori.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                deleteKategori(kategori.id);
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ================= WIDGET BUTTON KECIL =================
  Widget _buildSmallButton(String label, Color color, VoidCallback onTap,
      {bool isDelete = false}) {
    return SizedBox(
      width: 80,
      height: 28,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: color.withOpacity(0.5)),
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDelete) Icon(Icons.delete_outline, color: color, size: 14),
            Text(label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
KatDashboard_AdminPage() {
}
