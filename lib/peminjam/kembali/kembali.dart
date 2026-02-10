import 'package:flutter/material.dart';
import 'package:peminjam_alat/peminjam/kembali/menuggu_pengembalian.dart';

class KembaliPage extends StatelessWidget {
  // Terima data dari halaman sebelumnya (Halaman Riwayat/Beranda)
  final Map<String, dynamic> dataPeminjaman;

  const KembaliPage({super.key, required this.dataPeminjaman});

  @override
  Widget build(BuildContext context) {
    // Ambil data dari map
    final String namaAlat = dataPeminjaman['nama_alat'] ?? 'Tidak diketahui';
    final String tglPinjam = dataPeminjaman['tanggal_pinjam'] ?? '-';
    final String tglKembali = dataPeminjaman['tanggal_kembali'] ?? '-';
    final int total = dataPeminjaman['total_alat'] ?? 1;

    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildAlatCard(namaAlat, total),
                  const SizedBox(height: 15),
                  _buildInfoPeminjamanCard(tglPinjam, tglKembali),
                  const SizedBox(height: 30),
                  _buildButtonKembali(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 25, right: 25),
      decoration: const BoxDecoration(
        color: Color(0xFF8FAFB6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFD9D9D9),
            child: Icon(Icons.person, color: Colors.black54),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hallo, Selamat datang", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Rara Aramita Azura", 
                style: TextStyle(fontSize: 12, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAlatCard(String nama, int total) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 20),
          _alatRow(nama),
          const Divider(height: 20),
          Text("Total: $total alat", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _alatRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40, height: 40, 
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8)
            ),
            child: const Icon(Icons.inventory_2, size: 20, color: Colors.grey)
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          const Text("● Dipinjam", 
            style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInfoPeminjamanCard(String tglPinjam, String tglKembali) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(height: 20),
          _infoRow("Tanggal Pinjam", tglPinjam),
          _infoRow("Rencana Kembali", tglKembali),
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
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildButtonKembali(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8FAFB6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          // MENGHUBUNGKAN: Mengirim data ke halaman berikutnya
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MenungguPengembalianPage(
                dataPeminjaman: dataPeminjaman,
              ),
            ),
          );
        },
        child: const Text("Kembalikan", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}