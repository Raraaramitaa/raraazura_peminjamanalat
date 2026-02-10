// ignore: file_names
import 'package:flutter/material.dart';

class MenungguPengembalianPage extends StatelessWidget {
  // MENGHUBUNGKAN: Menambahkan variabel untuk menerima data
  final Map<String, dynamic>? dataPeminjaman;

  const MenungguPengembalianPage({super.key, this.dataPeminjaman});

  @override
  Widget build(BuildContext context) {
    // Ambil data dinamis atau gunakan default jika null
    final String namaAlat = dataPeminjaman?['nama_alat'] ?? 'Tidak diketahui';
    final String tglKembali = dataPeminjaman?['tanggal_kembali'] ?? 'Hari ini';
    final int total = dataPeminjaman?['total_alat'] ?? 1;

    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Column(
        children: [
          _buildHeader(context), 
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSimpleCard([
                    const Text("Daftar Alat:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(),
                    // Data Nama Alat kini dinamis
                    _alatMiniRow(namaAlat),
                    const Divider(),
                    Text("Total: $total alat", style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 10),
                    const Text("Diverifikasi oleh: Petugas",
                        style: TextStyle(fontSize: 12)),
                    const Divider(),
                    const Text("Total Denda: Rp 0", // Bisa ditambahkan logika denda nanti
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 15),
                  _buildSimpleCard([
                    const Text("Informasi Pengembalian",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tanggal Kembali", style: TextStyle(fontSize: 12)),
                        Text(tglKembali,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    )
                  ]),
                  const SizedBox(height: 25),
                  _buildStatusCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 10),
      color: const Color(0xFF8FAFB6),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Text(
            "Pengajuan Berhasil",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12), // Diperhalus dari black87
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _alatMiniRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.inventory_2, size: 15, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(
            "● Diproses",
            style: TextStyle(
                color: Colors.blue, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFD4E9D7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: const Column(
        children: [
          Text(
            "Berhasil Dikembalikan",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 10),
          Icon(Icons.check_circle, color: Colors.green, size: 40),
          SizedBox(height: 10),
          Text(
            "Terima kasih telah meminjam\nalat di pinjam.yuk",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }
}