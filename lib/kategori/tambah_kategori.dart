import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'kategori.dart'; // Pastikan kelas Kategori di sini punya constructor yang cocok

class KategoriTambahPage extends StatefulWidget {
  const KategoriTambahPage({super.key});

  @override
  State<KategoriTambahPage> createState() => _KategoriTambahPageState();
}

class _KategoriTambahPageState extends State<KategoriTambahPage> {
  final TextEditingController _namaController = TextEditingController();
  String? _gambarPath;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          _gambarPath = picked.path;
        });
      }
    } catch (e) {
      // Menangani error jika akses galeri ditolak
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil gambar: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Kategori', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8FAFB6),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFBFD6DB),
      body: SingleChildScrollView( // Agar tidak error overflow saat keyboard muncul
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tambah Kategori Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Input Nama Kategori
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kategori',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                hintText: 'Masukkan nama kategori',
              ),
            ),
            const SizedBox(height: 20),

            // Area pilih gambar
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  image: _gambarPath != null
                      ? DecorationImage(
                          image: FileImage(File(_gambarPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _gambarPath == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Tambah Foto', style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Batal & Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded( // Menggunakan Expanded agar tombol simetris
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FAFB6),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_namaController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
                          );
                          return;
                        }

                        // Buat objek kategori baru
                        final newKategori = Kategori(
                          id: 0, // Beri nilai default 0 atau sesuaikan modelmu
                          nama: _namaController.text.trim(),
                          gambarPath: _gambarPath ?? '', // Hindari null jika model minta string
                        );

                        Navigator.pop(context, newKategori);
                      },
                      child: const Text('Simpan'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}