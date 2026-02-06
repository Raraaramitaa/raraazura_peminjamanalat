import 'package:flutter/material.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  bool _obscure = true;
  String _sebagai = 'Peminjam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= HEADER MELENGKUNG (DIPERKECIL) =================
          Container(
            height: 110, // ⬅️ DIPERKECIL
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80), // ⬅️ DISESUAIKAN
                bottomRight: Radius.circular(80),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Tambah Pengguna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18, // ⬅️ LEBIH PROPORSIONAL
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ================= FORM =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  _label('Nama'),
                  _input(hint: 'Masukkan nama'),

                  const SizedBox(height: 14),

                  _label('Email'),
                  _input(hint: 'Masukkan email'),

                  const SizedBox(height: 14),

                  _label('Password'),
                  _passwordInput(),

                  const SizedBox(height: 14),

                  _label('Sebagai'),
                  _dropdownInput(),

                  const SizedBox(height: 28),

                  // ================= BUTTON =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _button(
                        text: 'Simpan',
                        color: const Color(0xFFBFD6DB),
                        onTap: () {},
                      ),
                      _button(
                        text: 'Batal',
                        color: const Color(0xFFBFD6DB),
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ================= FOOTER MELENGKUNG (DIPERKECIL) =================
          Container(
            height: 55, // ⬅️ DIPERKECIL
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80), // ⬅️ DISESUAIKAN
                topRight: Radius.circular(80),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET =================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0C3B5A),
      ),
    );
  }

  Widget _input({required String hint}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF6B7DB3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF6B7DB3)),
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return TextField(
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: 'Masukkan password',
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() => _obscure = !_obscure);
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF6B7DB3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Color(0xFF6B7DB3)),
        ),
      ),
    );
  }

  Widget _dropdownInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF6B7DB3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sebagai,
          isExpanded: true,
          icon: const Icon(Icons.person),
          items: const [
            DropdownMenuItem(
              value: 'Peminjam',
              child: Text('Peminjam'),
            ),
            DropdownMenuItem(
              value: 'Petugas',
              child: Text('Petugas'),
            ),
          ],
          onChanged: (value) {
            setState(() => _sebagai = value!);
          },
        ),
      ),
    );
  }

  Widget _button({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
