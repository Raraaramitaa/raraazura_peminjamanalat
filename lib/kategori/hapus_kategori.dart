import 'package:flutter/material.dart';

class HapusKategoriDialog extends StatelessWidget {
  final String namaKategori;

  const HapusKategoriDialog({super.key, required this.namaKategori});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hapus Kategori'),
      content: Text('Kategori "$namaKategori" ini akan dihapus.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Ya, Hapus'),
        ),
      ],
    );
  }
}
