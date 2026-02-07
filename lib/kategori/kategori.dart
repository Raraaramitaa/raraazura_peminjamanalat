import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_kategori.dart';
import 'hapus_kategori.dart';
import 'tambah_kategori.dart';

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

    final data = await supabase
        .from('kategori')
        .select()
        .order('id_kategori');

    kategoriList = (data as List)
        .map(
          (e) => Kategori(
            id: e['id_kategori'],
            nama: e['nama_kategori'] ?? '',
            gambarUrl: e['gambar_url'],
          ),
        )
        .toList();

    setState(() => loading = false);
  }

  Future<void> deleteKategori(int id) async {
    await supabase.from('kategori').delete().eq('id_kategori', id);
    kategoriList.removeWhere((e) => e.id == id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = kategoriList
        .where((k) => k.nama.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        title: const Text('Daftar Kategori'),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔍 Search + Tambah
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Cari kategori alat...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (v) => setState(() => searchQuery = v),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB6),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah kategori'),
                  onPressed: () async {
                    final result = await Navigator.push<Kategori>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const KategoriTambahPage(),
                      ),
                    );
                    if (result != null) {
                      kategoriList.add(result);
                      setState(() {});
                    }
                  },
                )
              ],
            ),

            const SizedBox(height: 12),

            // 📋 List kategori
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredList.isEmpty
                      ? const Center(child: Text('Kategori tidak ditemukan'))
                      : ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final kategori = filteredList[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7D9DE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  // 🖼 Gambar
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      image: kategori.gambarUrl != null
                                          ? DecorationImage(
                                              image:
                                                  NetworkImage(kategori.gambarUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: kategori.gambarUrl == null
                                        ? const Icon(Icons.category,
                                            size: 40, color: Colors.grey)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),

                                  // 📄 Nama
                                  Expanded(
                                    child: Text(
                                      kategori.nama,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // ✏️ Edit
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () async {
                                            final edited =
                                                await Navigator.push<Kategori>(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    KategoriEditPage(
                                                        kategori: kategori),
                                              ),
                                            );
                                            if (edited != null) {
                                              final i = kategoriList.indexWhere(
                                                  (e) => e.id == edited.id);
                                              kategoriList[i] = edited;
                                              setState(() {});
                                            }
                                          },
                                          child: const Text('Edit',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red[300],
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () async {
                                            final ok = await showDialog<bool>(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (_) =>
                                                  HapusKategoriDialog(
                                                      namaKategori:
                                                          kategori.nama),
                                            );
                                            if (ok == true) {
                                              await deleteKategori(kategori.id);
                                            }
                                          },
                                          child: const Text('Hapus',
                                              style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                    ],
                                  )
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

// ================= MODEL =================

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
