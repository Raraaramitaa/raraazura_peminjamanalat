// Mengabaikan warning unused import & penggunaan context async
// ignore_for_file: unused_import, use_build_context_synchronously

// Import package utama Flutter
import 'package:flutter/material.dart';

// Import Supabase untuk autentikasi & database
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman berdasarkan role
import 'package:peminjam_alat/admin/dashboard_admin.dart';
import 'package:peminjam_alat/petugas/dashboard_petugas.dart';
import 'package:peminjam_alat/peminjam/dashboard_peminjam.dart';


// =========================================================
// HALAMAN LOGIN
// =========================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Controller untuk input email
  final _emailController = TextEditingController();

  // Controller untuk input password
  final _passwordController = TextEditingController();

  // Untuk menyembunyikan / menampilkan password
  bool _obscure = true;

  // Status loading saat proses login
  bool _loading = false;

  // Inisialisasi Supabase client
  final SupabaseClient supabase = Supabase.instance.client;


  // Dispose controller saat halaman ditutup (menghindari memory leak)
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  // =========================================================
  // FUNGSI LOGIN
  // =========================================================
  Future<void> _login() async {

    // Ambil nilai dari input dan hilangkan spasi
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi jika kosong
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan password wajib diisi');
      return;
    }

    // Aktifkan loading
    setState(() => _loading = true);

    try {

      // Proses login menggunakan Supabase Auth
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      // Ambil data user dari response
      final user = res.user;

      // Jika user tidak ditemukan
      if (user == null) throw const AuthException('User tidak ditemukan');

      // Ambil role dari tabel profiles berdasarkan id user
      final profile = await supabase
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .maybeSingle();

      // Jika profil tidak ada
      if (profile == null) throw 'Data profil tidak ditemukan di database';
      
      // Cek apakah widget masih mounted (aman untuk navigasi)
      if (!mounted) return;

      // Ambil role
      final String role = profile['role'];

      // Variabel tujuan halaman
      Widget targetPage;

      // Navigasi berdasarkan role
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

      // Pindah halaman dan hapus semua halaman sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => targetPage),
        (route) => false,
      );

    } 
    // Jika error dari Supabase Auth
    on AuthException catch (e) {
      _showSnackBar(e.message);
    } 
    // Jika error lainnya
    catch (e) {
      _showSnackBar('Gagal login: ${e.toString()}');
    } 
    finally {
      // Matikan loading jika widget masih aktif
      if (mounted) setState(() => _loading = false);
    }
  }


  // =========================================================
  // MENAMPILKAN SNACKBAR
  // =========================================================
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  // =========================================================
  // BUILD UI
  // =========================================================
  @override
  Widget build(BuildContext context) {

    // GestureDetector untuk menutup keyboard saat tap luar field
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
              
              // ================= LOGO =================
              Container(
                height: 280,
                width: 280,
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
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.developer_board,
                            size: 150,
                            color: Color(0xFF0C3B5A)),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // ================= FORM LOGIN =================
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

                    // Field Email
                    _buildTextField(
                      controller: _emailController,
                      hint: 'Masukkan Email',
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 25),

                    // Field Password
                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Masukkan Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscure: _obscure,
                      onToggle: () => setState(() => _obscure = !_obscure),
                    ),

                    const SizedBox(height: 45),
                    
                    // Tombol Masuk
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
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


  // =========================================================
  // WIDGET TEXTFIELD CUSTOM
  // =========================================================
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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
