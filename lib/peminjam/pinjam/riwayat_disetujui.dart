import 'package:flutter/material.dart';

class RiwayatDisetujuiPage extends StatelessWidget {
  final VoidCallback onReturn;

  const RiwayatDisetujuiPage({super.key, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        title: const Text("Detail Riwayat", style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const Divider(color: Colors.black26),
                _itemRow("ASUS Zenbook S 16 (UM5606)"),
                _itemRow("SAMSUNG Galaxy Book4"),
                const Divider(color: Colors.black26),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                const Divider(color: Colors.black26),
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
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Disetujui\nPengajuan kamu sudah disetujui petugas. Silahkan ambil alat sesuai jadwal.",
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.4),
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
                    _actionButton("Kembalikan", const Color(0xFF8FAFB6), Colors.white, () {
                      Navigator.pop(context);
                      onReturn(); 
                    }),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.laptop, size: 35, color: Colors.black54),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          const Text("● Pinjam", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color text, VoidCallback onTap) {
    return SizedBox(
      width: 115,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          side: const BorderSide(color: Colors.black12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        child: Text(label, style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }
}