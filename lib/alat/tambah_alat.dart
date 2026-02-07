import 'package:flutter/material.dart';

class TambahAlatPage extends StatelessWidget {
  const TambahAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text("tambah alat", style: TextStyle(color: Colors.black45))),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF8FAFB6),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  // Placeholder Foto
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.white, thickness: 5, indent: 50, endIndent: 50),
                  const SizedBox(height: 20),
                  _buildInput("Nama", "Masukan nama alat"),
                  _buildInput("Stok", "Masukan stok alat"),
                  _buildDropdown("Status", "Pilih Status"),
                  _buildDropdown("Kategori", "Pilih kategori"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: hint, filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(hint), isExpanded: true,
                items: const [], onChanged: (v) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}