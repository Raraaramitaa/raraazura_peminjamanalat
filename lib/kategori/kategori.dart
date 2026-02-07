
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/kategori/edit_kategori.dart';
import 'package:peminjam_alat/kategori/hapus_kategori.dart';
import 'package:peminjam_alat/kategori/tambah_kategori.dart';

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
    final response = await supabase.from('kategori').select().order('id_kategori');
    final List data = response as List;
    kategoriList = data.map((e) {
      return Kategori(
        id: e['id_kategori'],
        nama: e['nama_kategori'] ?? '',
        gambarUrl: e['gambar_url'],
      );
    }).toList();
      setState(() => loading = false);
  }

  Future<void> deleteKategori(int id) async {
    final res = await supabase.from('kategori').delete().eq('id_kategori', id);
    if (res != null) {
      kategoriList.removeWhere((element) => element.id == id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Kategori> filteredList = kategoriList.where((k) {
      return k.nama.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        title: const Text('Daftar Kategori'),
        leading: const BackButton(color: Colors.black87),
      ),
      backgroundColor: const Color(0xFFBFD6DB),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Cari kategori ol...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB6),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah kategori'),
                  onPressed: () async {
                    final newKategori = await Navigator.push<Kategori>(
                      context,
                      MaterialPageRoute(builder: (_) => const KategoriTambahPage()),
                    );
                    if (newKategori != null) {
                      kategoriList.add(newKategori);
                      setState(() {});
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? const Center(child: Text("Kategori tidak ditemukan"))
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final kategori = filteredList[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey[200],
                                      image: kategori.gambarUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(kategori.gambarUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: kategori.gambarUrl == null
                                        ? const Icon(Icons.category, size: 40, color: Colors.black54)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      kategori.nama,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                      foregroundColor: Colors.black87,
                                      minimumSize: const Size(60, 32),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onPressed: () async {
                                      final editedKategori = await Navigator.push<Kategori>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => KategoriEditPage(kategori: kategori),
                                        ),
                                      );
                                      if (editedKategori != null) {
                                        final idx = kategoriList.indexWhere((k) => k.id == editedKategori.id);
                                        if (idx != -1) {
                                          kategoriList[idx] = editedKategori;
                                          setState(() {});
                                        }
                                      }
                                    },
                                    child: const Text('Edit'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[300],
                                      minimumSize: const Size(60, 32),
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (_) => HapusKategoriDialog(namaKategori: kategori.nama),
                                      );

                                      if (confirmed == true) {
                                        await deleteKategori(kategori.id);
                                      }
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
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

  Kategori({
    required this.id,
    required this.nama,
    this.gambarUrl, String? gambarPath,
  });

  String? get gambarPath => null;
}
