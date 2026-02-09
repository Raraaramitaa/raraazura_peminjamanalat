import 'package:flutter/material.dart';

class RiwayatDisetujuiPage extends StatelessWidget {
  const RiwayatDisetujuiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black87),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(color: Colors.black),
              _itemRow("ASUS Zenbook S 16 (UM5606)"),
              _itemRow("SAMSUNG Galaxy Book4"),
              const Divider(color: Colors.black),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(color: Colors.black),
              _infoRow("Tanggal Pinjam", "14 Januari 2026"),
              _infoRow("Tanggal Kembali", "16 Januari 2026"),
              _infoRow("Tanggal Tenggat", "15 Januari 2026"),
              _infoRow("Jam Ambil", "08.00 - 16.00"),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4E9D7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 40),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Disetujui\nPengajuan kamu sudah disetujui petugas. Silahkan ambil alat sesuai jadwal.",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton("Tutup", Colors.white, Colors.black, () => Navigator.pop(context)),
                  _actionButton("Kembalikan", const Color(0xFF8FAFB6), Colors.white, () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi helper _itemRow, _infoRow, dan _actionButton sama seperti di file RiwayatMenunggu
  Widget _itemRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.laptop, size: 40),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 11))),
          const Text("● Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color text, VoidCallback onTap) {
    return SizedBox(
      width: 110,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          side: const BorderSide(color: Colors.black26),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Text(label, style: TextStyle(color: text, fontSize: 11)),
      ),
    );
  }
}