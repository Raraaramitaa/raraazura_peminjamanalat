import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Pastikan inisialisasi Supabase sudah benar di main.dart Anda
  runApp(const MaterialApp(
    home: LoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedRole;

  bool _obscurePassword = true;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _login() async {
    if (_nameController.text.isEmpty || _passwordController.text.isEmpty || _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Logika login Supabase Anda di sini
      await supabase.auth.signInWithPassword(
        email: _nameController.text.trim(), // Asumsi nama digunakan sebagai identitas/email
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login berhasil"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFB1C3C9), // Warna background dasar
      body: Stack(
        children: [
          /// ===== BACKGROUND LAYER 1 (Gelombang Atas) =====
          Positioned(
            top: -size.height * 0.15,
            left: -size.width * 0.5,
            right: -size.width * 0.5,
            child: Container(
              height: size.height * 0.6,
              decoration: const BoxDecoration(
                color: Color(0xFFD9E2E5), // Warna lengkungan atas
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// ===== BACKGROUND LAYER 2 (Gelombang Bawah/Tengah) =====
          Positioned(
            bottom: -size.height * 0.25,
            left: -size.width * 0.2,
            right: -size.width * 0.2,
            child: Container(
              height: size.height * 0.5,
              decoration: const BoxDecoration(
                color: Color(0xFFD9E2E5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontFamily: 'Serif',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),

                    /// ===== LOGO BOX =====
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E94B5), Color(0xFF164C62)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: const Icon(Icons.memory, size: 65, color: Colors.white),
                    ),

                    const SizedBox(height: 15),
                    const Text(
                      "Pinjam.yuk",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C4E61),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const Text(
                      "(Sistem Peminjaman Alat Lab Brantas)",
                      style: TextStyle(fontSize: 11, color: Color(0xFF557A8F)),
                    ),

                    const SizedBox(height: 40),

                    /// ===== LOGIN CARD =====
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 45),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4), // Card transparan
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        children: [
                          // Input Nama
                          _buildInputWrapper(
                            child: TextField(
                              controller: _nameController,
                              decoration: _inputDecoration(Icons.mail_outline, "Masukkan Nama"),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Input Password
                          _buildInputWrapper(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                Icons.lock_outline,
                                "Masukkan Password",
                                isPassword: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Dropdown Masuk Sebagai
                          _buildInputWrapper(
                            child: DropdownButtonFormField<String>(
                              value: _selectedRole,
                              decoration: _inputDecoration(Icons.person_outline, "Masuk sebagai"),
                              icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
                              items: ["Mahasiswa", "Dosen", "Admin"]
                                  .map((label) => DropdownMenuItem(
                                        value: label,
                                        child: Text(label, style: const TextStyle(fontSize: 14)),
                                      ))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedRole = value),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Tombol Masuk
                          SizedBox(
                            width: 160, // Sesuai bentuk tombol di wireframe yang agak kecil
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8DA7B3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: const BorderSide(color: Color(0xFF5A8291), width: 1.5),
                                ),
                                elevation: 2,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text(
                                      "Masuk",
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Wrapper untuk konsistensi desain input
  Widget _buildInputWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF93ADB8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF5A8291), width: 1.5),
      ),
      child: child,
    );
  }

  // Styling dekorasi input
  InputDecoration _inputDecoration(IconData icon, String hint, {bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
      prefixIcon: Icon(icon, color: Colors.black87, size: 22),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.black87, size: 20),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            )
          : null,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    );
  }
}






