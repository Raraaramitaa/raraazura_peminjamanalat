import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/kategori/edit_kategori.dart';
import 'package:peminjam_alat/kategori/hapus_kategori.dart';
import 'package:peminjam_alat/kategori/tambah_kategori.dart';
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/alat/alat.dart';
// ignore: unused_import
import 'package:peminjam_alat/admin/logout.dart';
// Perbaikan: Import sendiri jika ada bentrok
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

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
    }
  }

  Future<void> deleteKategori(int id) async {
    await supabase.from('kategori').delete().eq('id_kategori', id);
    fetchKategori();
  }

  @override
  Widget build(BuildContext context) {
    List<Kategori> filteredList = kategoriList.where((k) {
      return k.nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= HEADER (APP BAR CUSTOM) =================
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
            ),
            child: Column(
              children: [
                Row(
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          ),

          // ================= SEARCH & ADD SECTION =================
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFFF0F0F0),
            child: Column(
              children: [
                Row(
                  children: [
                    // Search Box
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          onChanged: (value) => setState(() => searchQuery = value),
                          decoration: const InputDecoration(
                            hintText: 'Cari kategori alat...',
                            prefixIcon: Icon(Icons.search, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Search Icon Box (Kiri)
                    Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Icon(Icons.search),
                    ),
                    const SizedBox(width: 10),
                    // Tombol Tambah (Kanan)
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => const KategoriTambahPage()));
                          fetchKategori();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8FAFB6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              Text(' Tambah kategori', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ================= LIST ITEMS =================
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final kategori = filteredList[index];
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
                                image: kategori.gambarUrl != null
                                    ? DecorationImage(image: NetworkImage(kategori.gambarUrl!), fit: BoxFit.contain)
                                    : null,
                              ),
                              child: kategori.gambarUrl == null ? const Icon(Icons.image, size: 50) : null,
                            ),
                            const SizedBox(width: 15),
                            // Title
                            Expanded(
                              child: Text(
                                kategori.nama,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Buttons
                            Column(
                              children: [
                                _buildSmallButton('Edit', const Color(0xFF4A68FF), () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => KategoriEditPage(kategori: kategori))).then((_) => fetchKategori());
                                }),
                                const SizedBox(height: 8),
                                _buildSmallButton('Hapus', const Color(0xFFFF4A4A), () async {
                                  final confirmed = await showDialog<bool>(context: context, builder: (_) => HapusKategoriDialog(namaKategori: kategori.nama));
                                  if (confirmed == true) deleteKategori(kategori.id);
                                }, isDelete: true),
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
          currentIndex: 3,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardAdminPage()));
            } else if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PenggunaPage()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AlatPage()));
            } else if (index == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const kat.KategoriPage()));
            } else if (index == 5) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutPage()));
            }
          },
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

  Widget _buildSmallButton(String label, Color color, VoidCallback onTap, {bool isDelete = false}) {
    return SizedBox(
      width: 80,
      height: 28,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: color.withOpacity(0.5)),
          padding: EdgeInsets.zero,
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

class Kategori {
  final int id;
  String nama;
  String? gambarUrl;
  Kategori({required this.id, required this.nama, this.gambarUrl, String? gambarPath});

  String? get gambarPath => null;
}
