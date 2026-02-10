import 'package:flutter/material.dart';

class ValidasiDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Checkmark Bulat Hijau
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF76BA99),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Teks Konten
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Validasi Pembayaran?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Pembayaran denda sebesar Rp 20.000 telah diterima. Silahkan lakukan validasi pembayaran denda.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Tombol Aksi
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Tombol Tutup
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFD9D9D9),
                        minimumSize: const Size(90, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup',
                          style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    // Tombol Validasi
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF8BA9B9),
                        minimumSize: const Size(90, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      onPressed: () {
                        // Tambahkan logika update status denda di Supabase di sini jika perlu
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pembayaran Berhasil Divalidasi'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Validasi',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}