import 'package:flutter/material.dart';

class EditAlatPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const EditAlatPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      body: Stack(
        children: [
          // Background Putih Lengkung di Bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.elliptical(400, 100)),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text("edit alat", style: TextStyle(color: Colors.black54)),
                const SizedBox(height: 20),
                // Foto Produk Melingkar
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/camera.png'), // Sesuaikan asset
                        ),
                      ),
                      const Positioned(
                        bottom: 5, right: 5,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFF7A98A0),
                          child: Icon(Icons.edit, size: 18, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Text("Sonny Camera", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                _buildField("Status", "Terpinjam"),
                _buildField("Stok", "2"),
                _buildDropdownField("Kategori", "Camera"),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildBtn("Batal", const Color(0xFFBFD6DB), Colors.black, () => Navigator.pop(context)),
                    _buildBtn("Simpan", Colors.white, Colors.black, () {}),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value, isExpanded: true,
              items: [value].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(String txt, Color bg, Color tc, VoidCallback tap) {
    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        onPressed: tap,
        style: ElevatedButton.styleFrom(backgroundColor: bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        child: Text(txt, style: TextStyle(color: tc, fontWeight: FontWeight.bold)),
      ),
    );
  }
}