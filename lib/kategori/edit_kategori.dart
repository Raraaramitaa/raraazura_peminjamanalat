import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // Import asli image_picker
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

  final ImagePicker _picker = ImagePicker();  // Instance ImagePicker

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.kategori.nama);
    _gambarPath = widget.kategori.gambarPath;
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _gambarPath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kategori'),
        backgroundColor: const Color(0xFF8FAFB6),
      ),
      backgroundColor: const Color(0xFFBFD6DB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Edit Kategori Anda',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Kategori',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
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
                          Icon(Icons.camera_alt, size: 40),
                          SizedBox(height: 10),
                          Text('Ubah Foto'),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_namaController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Nama kategori tidak boleh kosong')),
                      );
                      return;
                    }
                    final editedKategori = Kategori(
                      id: widget.kategori.id, // Jangan lupa bawa id lama supaya update valid
                      nama: _namaController.text.trim(),
                      gambarPath: _gambarPath,
                    );
                    Navigator.pop(context, editedKategori);
                  },
                  child: const Text('Simpan Perubahan'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
