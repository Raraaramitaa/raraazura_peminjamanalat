// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _obscure = true;
  bool _isLoading = false;
  String _sebagai = 'Peminjam';

  // =========================================================
  // LOGIKA SIMPAN DATA (AUTH + DATABASE) - SUDAH DIPERBAIKI
  // =========================================================
  Future<void> _simpanData() async {
    // 1. Validasi Input
    String namaValue = _namaController.text.trim();
    String emailValue = _emailController.text.trim();
    String passwordValue = _passwordController.text.trim();

    if (namaValue.isEmpty || emailValue.isEmpty || passwordValue.isEmpty) {
      _showSnackBar('⚠️ Semua data wajib diisi!', Colors.orange);
      return;
    }

    if (passwordValue.length < 6) {
      _showSnackBar('⚠️ Password minimal 6 karakter!', Colors.orange);
      return;
    }

    // Tutup keyboard
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      // 2. PROSES DAFTAR KE AUTH SUPABASE
      // Note: Pastikan di dashboard Supabase > Auth > Providers > Email, 
      // bagian "Confirm Email" DIMATIKAN jika tidak ingin verifikasi email manual.
      final AuthResponse res = await supabase.auth.signUp(
        email: emailValue,
        password: passwordValue,
        data: {
          'full_name': namaValue,
          'role': _sebagai.toLowerCase(),
        },
      );

      final user = res.user;

      if (user != null) {
        // 3. PROSES SIMPAN KE TABEL PROFILES (DENGAN RE-TRY LOGIC)
        // Menggunakan upsert agar jika id sudah ada akan diupdate, jika belum akan ditambah
        await supabase.from('profiles').upsert({
          'id': user.id, // ID diambil dari Auth UID
          'Nama': namaValue, 
          'email': emailValue,
          'role': _sebagai.toLowerCase(),
          'created_at': DateTime.now().toIso8601String(),
        });

        if (mounted) {
          _showSnackBar('✅ Pengguna berhasil ditambahkan!', Colors.green);
          
          // Reset form setelah berhasil
          _namaController.clear();
          _emailController.clear();
          _passwordController.clear();

          // Kembali ke halaman sebelumnya setelah 1 detik
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context, true);
        }
      }
    } on AuthException catch (error) {
      // Menangani error rate limit (terlalu sering klik)
      if (error.statusCode == '429' || error.message.contains('seconds')) {
        _showSnackBar('⏳ Terlalu banyak percobaan. Tunggu sebentar lagi.', Colors.red.shade800);
      } else {
        _showSnackBar('❌ Gagal Daftar: ${error.message}', Colors.red);
      }
    } catch (e) {
      debugPrint('Sistem Error: $e');
      _showSnackBar('❌ Terjadi kesalahan pada server database', Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =========================================================
  // UI DESIGN
  // =========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
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
                  _input(hint: 'Masukkan alamat email', controller: _emailController, type: TextInputType.emailAddress),
                  const SizedBox(height: 14),
                  _label('Password'),
                  _passwordInput(controller: _passwordController),
                  const SizedBox(height: 14),
                  _label('Sebagai'),
                  _dropdownInput(),
                  const SizedBox(height: 35),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator(color: Color(0xFF8FAFB6)))
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _button(text: 'Simpan', color: const Color(0xFFBFD6DB), onTap: _simpanData),
                        _button(text: 'Batal', color: Colors.grey.shade200, onTap: () => Navigator.pop(context)),
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
    height: 110, width: double.infinity,
    decoration: const BoxDecoration(
      color: Color(0xFF8FAFB6),
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80), bottomRight: Radius.circular(80))
    ),
    alignment: Alignment.center,
    child: const Text('Tambah Pengguna', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
  );

  Widget _buildFooter() => Container(
    height: 55, width: double.infinity,
    decoration: const BoxDecoration(
      color: Color(0xFF8FAFB6),
      borderRadius: BorderRadius.only(topLeft: Radius.circular(80), topRight: Radius.circular(80))
    ),
  );

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(left: 8, bottom: 4),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0C3B5A))),
  );

  Widget _input({required String hint, required TextEditingController controller, TextInputType type = TextInputType.text}) => TextField(
    controller: controller,
    keyboardType: type,
    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF6B7DB3))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: const BorderSide(color: Color(0xFF0C3B5A), width: 1.5)),
    ),
  );

  Widget _passwordInput({required TextEditingController controller}) => TextField(
    controller: controller,
    obscureText: _obscure,
    style: const TextStyle(fontSize: 14),
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

  Widget _dropdownInput() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0xFF6B7DB3))),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _sebagai,
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xFF6B7DB3)),
        style: const TextStyle(color: Colors.black, fontSize: 14),
        items: const [
          DropdownMenuItem(value: 'Peminjam', child: Text('Peminjam')),
          DropdownMenuItem(value: 'Petugas', child: Text('Petugas')),
        ],
        onChanged: (value) => setState(() => _sebagai = value!),
      ),
    ),
  );

  Widget _button({required String text, required Color color, required VoidCallback onTap}) => SizedBox(
    width: 130, height: 48,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color, 
        elevation: 2, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(color: Color(0xFF0C3B5A), fontWeight: FontWeight.bold)),
    ),
  );
}