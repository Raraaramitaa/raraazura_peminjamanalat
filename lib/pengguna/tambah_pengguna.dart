import 'package:flutter/material.dart';

// Model data untuk dikirim balik ke halaman daftar
class UserData {
  final String nama;
  final String email;
  final String sebagai;

  UserData({required this.nama, required this.email, required this.sebagai});
}

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _obscure = true;
  String _sebagai = 'Peminjam';

  void _simpanData() {
    String nama = _namaController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Semua data wajib diisi!'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Membuat objek data
    final penggunaBaru = UserData(
      nama: nama,
      email: email,
      sebagai: _sebagai,
    );

    // KUNCI: Mengirim data objek kembali ke halaman sebelumnya
    Navigator.pop(context, penggunaBaru);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            height: 110,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Tambah Pengguna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _label('Nama'),
                  _input(hint: 'Masukkan nama lengkap', controller: _namaController),
                  const SizedBox(height: 14),
                  _label('Email'),
                  _input(hint: 'Masukkan alamat email', controller: _emailController),
                  const SizedBox(height: 14),
                  _label('Password'),
                  _passwordInput(controller: _passwordController),
                  const SizedBox(height: 14),
                  _label('Sebagai'),
                  _dropdownInput(),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _button(
                        text: 'Simpan',
                        color: const Color(0xFFBFD6DB),
                        onTap: _simpanData, 
                      ),
                      _button(
                        text: 'Batal',
                        color: Colors.grey.shade200,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            height: 55,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0C3B5A))),
    );
  }

  Widget _input({required String hint, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF6B7DB3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF0C3B5A), width: 1.5)),
      ),
    );
  }

  Widget _passwordInput({required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: 'Masukkan password',
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF6B7DB3)),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF6B7DB3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF0C3B5A), width: 1.5)),
      ),
    );
  }

  Widget _dropdownInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0xFF6B7DB3))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sebagai,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF6B7DB3)),
          items: const [
            DropdownMenuItem(value: 'Peminjam', child: Text('Peminjam')),
            DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
          ],
          onChanged: (value) => setState(() => _sebagai = value!),
        ),
      ),
    );
  }

  Widget _button({required String text, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: 130, height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(color: Color(0xFF0C3B5A), fontWeight: FontWeight.bold)),
      ),
    );
  }
}