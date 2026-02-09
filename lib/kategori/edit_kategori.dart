// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart'; // Wajib untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/kategori/kategori.dart';

// Import dart:io secara aman agar tidak error di Web
import 'dart:io' as io; 

class KategoriEditPage extends StatefulWidget {
  final Kategori kategori;

  const KategoriEditPage({super.key, required this.kategori});

  @override
  State<KategoriEditPage> createState() => _KategoriEditPageState();
}

class _KategoriEditPageState extends State<KategoriEditPage> {
  late TextEditingController _namaController;
  
  // Variabel untuk menampung data gambar
  String? _gambarPath; 
  XFile? _imageFile; 
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    // Mengisi data awal dari objek kategori
    _namaController = TextEditingController(text: widget.kategori.nama);
    _gambarPath = widget.kategori.gambarPath;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  // ================= FUNGSI AMBIL GAMBAR =================
  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50, 
      );

      if (picked != null) {
        setState(() {
          _imageFile = picked;
          _gambarPath = picked.path; 
        });
      }
    } catch (e) {
      _showSnackBar('Gagal mengambil gambar: $e');
    }
  }

  // ================= FUNGSI SIMPAN (UPDATE) =================
  Future<void> _simpanPerubahan() async {
    final namaBaru = _namaController.text.trim();

    if (namaBaru.isEmpty) {
      _showSnackBar('Nama kategori tidak boleh kosong');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? finalImageUrl = widget.kategori.gambarPath;

      // 1. Logika Upload Gambar Baru jika ada
      if (_imageFile != null) {
        final fileName = 'cat_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final uploadPath = 'kategori/$fileName';

        if (kIsWeb) {
          // Khusus Web: Harus dibaca sebagai Bytes
          final bytes = await _imageFile!.readAsBytes();
          await supabase.storage.from('kategori_images').uploadBinary(
                uploadPath,
                bytes,
                fileOptions: const FileOptions(contentType: 'image/jpeg', upsert: true),
              );
        } else {
          // Khusus Mobile: Menggunakan File Path
          final file = io.File(_imageFile!.path);
          await supabase.storage.from('kategori_images').upload(
                uploadPath, 
                file,
                fileOptions: const FileOptions(upsert: true),
              );
        }

        // Ambil URL publik gambar yang baru diupload
        finalImageUrl = supabase.storage.from('kategori_images').getPublicUrl(uploadPath);
      }

      // 2. Update Database Supabase
      // CATATAN: Pastikan kolom 'nama_kategori' dan 'gambar_url' ada di tabel 'kategori' Anda
      await supabase.from('kategori').update({
        'nama_kategori': namaBaru,
        'gambar_url': finalImageUrl, 
      }).eq('id_kategori', widget.kategori.id);

      if (mounted) {
        _showSnackBar('Kategori berhasil diperbarui');
        Navigator.pop(context, true); 
      }
    } catch (e) {
      debugPrint('Eror Detail: $e');
      _showSnackBar('Terjadi kesalahan: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating)
    );
  }

  // ================= UI PREVIEW GAMBAR =================
  Widget _buildImagePreview() {
    if (_imageFile != null) {
      if (kIsWeb) {
        return Image.network(_imageFile!.path, fit: BoxFit.cover);
      } else {
        return Image.file(io.File(_imageFile!.path), fit: BoxFit.cover);
      }
    }

    if (_gambarPath != null && _gambarPath!.startsWith('http')) {
      return Image.network(
        _gambarPath!, 
        fit: BoxFit.cover, 
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, size: 50)),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          Text('Klik untuk ganti foto', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kategori'),
        backgroundColor: const Color(0xFF8FAFB6),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFBFD6DB),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Update Kategori Alat',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0C3B5A)),
                  ),
                ),
                const SizedBox(height: 25),
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
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Foto Kategori", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: _buildImagePreview(),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
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
                        onPressed: _isLoading ? null : _simpanPerubahan,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20, 
                                width: 20, 
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Simpan Perubahan', 
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}