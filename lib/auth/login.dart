// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/petugas/dashboard_petugas.dart';
import 'package:peminjam_alat/peminjam/dashboard_peminjam.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan password wajib diisi');
      return;
    }

    setState(() => _loading = true);

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) throw const AuthException('User tidak ditemukan');

      final profile = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) throw 'Data profil tidak ditemukan di database';
      
      if (!mounted) return;

      final String role = profile['role'];
      Widget targetPage;

      switch (role) {
        case 'admin':
          targetPage = const DashboardAdminPage(); 
          break;
        case 'petugas':
          targetPage = const DashboardPetugasPage();
          break;
        case 'peminjam':
          targetPage = const DashboardPeminjamPage();
          break;
        default:
          throw 'Role "$role" tidak dikenali oleh sistem';
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => targetPage),
        (route) => false,
      );

    } on AuthException catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar('Gagal login: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                width: double.infinity,
                height: 120,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF8FAFB6),
                ),
                child: const SafeArea(
                  child: Text(
                    'Selamat Datang',
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // ================= LOGO SECTION (DIPERBESAR MAKSIMAL) =================
              Container(
                height: 280, // UKURAN RAKSASA
                width: 280,  // UKURAN RAKSASA
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain, // Memastikan seluruh logo terlihat tanpa terpotong
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.developer_board, size: 150, color: Color(0xFF0C3B5A)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // ================= FORM UTAMA =================
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                decoration: BoxDecoration(
                  color: const Color(0xFFB4C8CC), 
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Masukkan Email',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 25),
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Masukkan Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscure: _obscure,
                      onToggle: () => setState(() => _obscure = !_obscure),
                    ),
                    const SizedBox(height: 45),
                    
                    // Button Masuk
                    SizedBox(
                      width: 180,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8FAFB6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(color: Colors.black87),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscure : false,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black87, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility, 
                    color: Colors.black87,
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF8FAFB6),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.black87),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.black, width: 1.2),
          ),
        ),
      ),
    );
  }
}