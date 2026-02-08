import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Dashboard sesuai role
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      if (user == null) throw const AuthException('Login gagal');

      final profile = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) throw 'Role tidak ditemukan';

      Widget target;
      switch (profile['role']) {
        case 'admin':
          target = const DashboardAdminPage();
          break;
        case 'petugas':
          target = const DashboardPetugasPage();
          break;
        case 'peminjam':
          target = const DashboardPeminjamPage();
          break;
        default:
          throw 'Role tidak dikenali';
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => target),
        (_) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal login: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // BACKGROUND LENGKUNGAN BAWAH
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.28,
                decoration: const BoxDecoration(
                  color: Color(0xFF8FAFB6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(250),
                    topRight: Radius.circular(250),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // HEADER ATAS
                    Container(
                      width: double.infinity,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8FAFB6),
                      ),
                      child: const Text(
                        'Selamat Datang',
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    const SizedBox(height: 60),

                    // ================= LOGO (DIPERBESAR) =================
                    SizedBox(
                      height: 230, // 🔥 LOGO DIPERBESAR
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image,
                                size: 140, color: Colors.grey),
                      ),
                    ),
                    // ======================================================

                    const SizedBox(height: 20),

                    const Text(
                      'Pinjam.yuk',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0C3B5A),
                      ),
                    ),
                    const Text(
                      '(Sistem Peminjaman Alat Lab Brantas)',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0C3B5A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // CARD LOGIN
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 35),
                      padding: const EdgeInsets.symmetric(
                          vertical: 50, horizontal: 30),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB6CED3),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _emailController,
                            hint: 'Masukkan Email',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 25),
                          _buildTextField(
                            controller: _passwordController,
                            hint: 'Masukkan Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscure: _obscure,
                            onToggle: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                          const SizedBox(height: 50),

                          SizedBox(
                            width: 170,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF8FAFB6),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(
                                      color: Colors.black54, width: 1.2),
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
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
    return TextField(
      controller: controller,
      obscureText: isPassword ? obscure : false,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black87, size: 24),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  size: 22,
                  color: Colors.black54,
                ),
                onPressed: onToggle,
              )
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF8FAFB6),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black87, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black, width: 1.8),
        ),
      ),
    );
  }
}
