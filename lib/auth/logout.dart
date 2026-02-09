import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/auth/login.dart'; // Sesuaikan path ini dengan project Anda

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  final supabase = Supabase.instance.client;
  bool _isLoading = false;

  // Fungsi untuk Logout
  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);

    try {
      await supabase.auth.signOut();
      if (mounted) {
        // Kembali ke halaman Login dan hapus semua history navigasi
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal keluar: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil data user yang sedang aktif dari Supabase
    final user = supabase.auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER PROFIL ---
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8FAFB6),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(150),
                      bottomRight: Radius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFD9D9D9),
                          child: Icon(Icons.person, size: 65, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user?.userMetadata?['full_name'] ?? user?.email?.split('@')[0] ?? "User Petugas",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- FORM INFORMASI USER ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoField("Nama", user?.userMetadata?['full_name'] ?? "Rara Aramita Azura"),
                  const SizedBox(height: 20),
                  _buildInfoField("Email", user?.email ?? "Tidak ada email"),
                  const SizedBox(height: 20),
                  _buildInfoField("Password", "********"), 
                ],
              ),
            ),

            const SizedBox(height: 50), 

            // --- TOMBOL KELUAR ---
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 160,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB6),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          "Keluar",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Box Informasi
  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF8FAFB6).withOpacity(0.6),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}