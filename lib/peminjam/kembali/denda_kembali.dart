import 'package:flutter/material.dart';

class DendaRiwayatPage extends StatelessWidget {
  const DendaRiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  _buildDaftarAlatDenda(),
                  const SizedBox(height: 15),
                  _buildPeringatanDenda(),
                  const SizedBox(height: 15),
                  _buildRingkasanPembayaran(),
                  const SizedBox(height: 30),
                  _buildButtonBayar(),
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
      padding: const EdgeInsets.only(top: 60, bottom: 25, left: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF8FAFB6),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Row(
        children: [
          CircleAvatar(backgroundColor: Color(0xFFD9D9D9), child: Icon(Icons.person)),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hallo, Selamat datang", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Rara Aramita Azura", style: TextStyle(fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDaftarAlatDenda() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black87)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold)),
          Divider(),
          _DendaItemRow("ASUS Zenbook S 16 (UM5606)"),
          _DendaItemRow("SAMSUNG Galaxy Book4"),
          Divider(),
          _DendaInfoRow("Tanggal Pinjam", "14 Januari 2026"),
          _DendaInfoRow("Tanggal Kembali", "16 Januari 2026"),
          _DendaInfoRow("Tanggal Pengembalian", "17 Januari 2026"),
        ],
      ),
    );
  }

  Widget _buildPeringatanDenda() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFFFD4D4), borderRadius: BorderRadius.circular(10)),
      child: const Row(
        children: [
          Icon(Icons.warning, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Denda", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                Text("Denda akibat keterlambatan dan kerusakan alat. Silakan lakukan pembayaran segera sesuai rincian.", 
                  style: TextStyle(fontSize: 10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRingkasanPembayaran() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black87)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ringkasan Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _ringkasanRow("Denda Telat", "Rp 20.000"),
          const Divider(),
          _ringkasanRow("TOTAL", "Rp 20.000", isBold: true),
          const Divider(),
          _ringkasanRow("Metode", "Tunai"),
        ],
      ),
    );
  }

  Widget _ringkasanRow(String label, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildButtonBayar() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8FAFB6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: () {},
        child: const Text("Bayar", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _DendaItemRow extends StatelessWidget {
  final String name;
  const _DendaItemRow(this.name);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const Icon(Icons.laptop, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 11))),
          const Text("● Tersedia", style: TextStyle(color: Colors.green, fontSize: 10)),
        ],
      ),
    );
  }
}

class _DendaInfoRow extends StatelessWidget {
  final String label, val;
  const _DendaInfoRow(this.label, this.val);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11)),
          Text(val, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}