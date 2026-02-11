import 'package:flutter/material.dart';

class HapusAlatDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const HapusAlatDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Hapus",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Apakah anda yakin ingin\nmenghapus barang ini?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Tombol Ya
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Tutup dialognya dulu agar tidak menumpuk di UI
                    Navigator.pop(context); 
                    // 2. Jalankan fungsi hapus (setState & Supabase) di alat.dart
                    onConfirm(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Ya", style: TextStyle(color: Colors.white)),
                ),
              ),
              // Tombol Tidak
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Tidak", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}