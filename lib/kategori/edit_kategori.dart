// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peminjam_alat/kategori/kategori.dart';

class KategoriEditPage extends StatefulWidget {
  final Kategori kategori;

  const KategoriEditPage({super.key, required this.kategori});

  @override
  State<KategoriEditPage> createState() => _KategoriEditPageState();
}

class _KategoriEditPageState extends State<KategoriEditPage> {
  late TextEditingController _namaController;
  String? _gambarPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data lama
    _namaController = TextEditingController(text: widget.kategori.nama);
    _gambarPath = widget.kategori.gambarPath;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Optimasi ukuran gambar
      );
      
      if (picked != null) {
        setState(() {
          _gambarPath = picked.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  void _simpanPerubahan() {
    final namaBaru = _namaController.text.trim();

    if (namaBaru.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }

    // Membuat objek kategori baru dengan data yang diupdate
    final editedKategori = Kategori(
      id: widget.kategori.id, // Pastikan ID tetap sama
      nama: namaBaru,
      gambarPath: _gambarPath,
    );

    // Mengirim kembali objek yang sudah diedit ke halaman sebelumnya
    Navigator.pop(context, editedKategori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kategori'),
        backgroundColor: const Color(0xFF8FAFB6),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFBFD6DB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Edit Kategori Anda',
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C3B5A)
                ),
              ),
            ),
            const SizedBox(height: 25),
            
            // Input Nama Kategori
            const Text("Nama Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama kategori',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Bagian Foto
            const Text("Foto Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: _gambarPath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          File(_gambarPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('Gagal memuat gambar'));
                          },
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_outlined, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Klik untuk ubah foto', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal', style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFF8FAFB6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _simpanPerubahan,
                    child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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