// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class AjukanPeminjamanPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const AjukanPeminjamanPage({super.key, required this.items});

  @override
  State<AjukanPeminjamanPage> createState() => _AjukanPeminjamanPageState();
}

class _AjukanPeminjamanPageState extends State<AjukanPeminjamanPage> {
  // 1. Definisikan Controller untuk setiap input agar bisa diketik dan diambil datanya
  final TextEditingController _tglAmbilController = TextEditingController(text: "12/01/2026");
  final TextEditingController _jamAmbilController = TextEditingController(text: "10:00");
  
  final TextEditingController _tglKembaliController = TextEditingController(text: "15/01/2026");
  final TextEditingController _jamKembaliController = TextEditingController(text: "14:00");
  
  final TextEditingController _tglTenggatController = TextEditingController(text: "14/01/2026");
  final TextEditingController _jamTenggatController = TextEditingController(text: "14:00");

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus dari memori
    _tglAmbilController.dispose();
    _jamAmbilController.dispose();
    _tglKembaliController.dispose();
    _jamKembaliController.dispose();
    _tglTenggatController.dispose();
    _jamTenggatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBCCDCF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Konfirmasi Pinjaman',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List Item
                  ...widget.items.map((item) {
                    return _buildItemCard(item);
                  // ignore: unnecessary_to_list_in_spreads
                  }).toList(),

                  const SizedBox(height: 10),

                  _buildSectionTitle("Ambil"),
                  _buildDateTimeEditRow(_tglAmbilController, _jamAmbilController),
                  
                  const SizedBox(height: 15),
                  _buildSectionTitle("Kembali"),
                  _buildDateTimeEditRow(_tglKembaliController, _jamKembaliController),
                  
                  const SizedBox(height: 15),
                  _buildSectionTitle("Tenggat Pengembalian"),
                  _buildDateTimeEditRow(_tglTenggatController, _jamTenggatController),
                ],
              ),
            ),
          ),

          // Bottom Panel
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: ${widget.items.length} jenis alat',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika mengambil data hasil ketikan user:
                      // String tanggalAmbil = _tglAmbilController.text;
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Pengajuan Berhasil Dikirim!")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8FAFB6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kirim Pengajuan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // 2. Widget yang diperbaiki agar menggunakan TextField (Bisa diketik)
  Widget _buildDateTimeEditRow(TextEditingController dateCtrl, TextEditingController timeCtrl) {
    return Row(
      children: [
        // Input Tanggal
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: dateCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.calendar_month_outlined, size: 20, color: Colors.black87),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black45),
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Input Jam
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: timeCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.access_time, size: 20, color: Colors.black87),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black45),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black45),
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: (item['foto'] != null && item['foto'].isNotEmpty)
                ? Image.network(item['foto'], fit: BoxFit.contain)
                : const Icon(Icons.laptop_mac, size: 40),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama'] ?? 'Alat Tidak Diketahui',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  item['kategori'] ?? 'Kategori',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 5),
                Text(
                  "Jumlah: ${item['jumlah']}",
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}