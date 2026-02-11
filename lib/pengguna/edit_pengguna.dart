// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPenggunaPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditPenggunaPage({super.key, required this.userData});

  @override
  State<EditPenggunaPage> createState() => _EditPenggunaPageState();
}

class _EditPenggunaPageState extends State<EditPenggunaPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  bool _obscure = true;
  bool _isLoading = false;
  String _jenisAkun = 'Peminjam';

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang dikirim dari halaman daftar
    _emailController = TextEditingController(text: widget.userData['email']?.toString() ?? '');
    _passwordController = TextEditingController();
    
    // Sesuaikan Role agar Dropdown terpilih otomatis sesuai data lama
    String roleAwal = widget.userData['role']?.toString().toLowerCase() ?? 'peminjam';
    if (roleAwal == 'admin') {
      _jenisAkun = 'Admin';
    } else if (roleAwal == 'petugas') {
      _jenisAkun = 'Petugas';
    } else {
      _jenisAkun = 'Peminjam';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FUNGSI UPDATE DATA ---
  Future<void> _updatePengguna() async {
    if (_emailController.text.isEmpty) {
      _showToast('Email tidak boleh kosong!', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Menggunakan 'id' karena di PenggunaPage anda memetakan 'id_user' ke 'id'
      final String userId = widget.userData['id'].toString(); 
      final String newEmail = _emailController.text.trim();
      final String newPassword = _passwordController.text.trim();

      // 1. UPDATE TABEL 'users' (Sesuai dengan kode daftar Anda)
      await supabase.from('users').update({
        'email': newEmail,
        'role': _jenisAkun.toLowerCase(),
      }).eq('id_user', userId); // Menggunakan id_user sesuai PK tabel users

      // 2. UPDATE PASSWORD DI SUPABASE AUTH (OPSIONAL)
      if (newPassword.isNotEmpty) {
        if (newPassword.length < 6) throw "Sandi minimal 6 karakter!";
        await supabase.auth.admin.updateUserById(
          userId,
          attributes: AdminUserAttributes(password: newPassword),
        );
      }

      if (mounted) {
        _showToast('✅ Berhasil memperbarui data', Colors.green);
        
        // PENTING: Mengembalikan nilai 'true' agar halaman daftar memanggil fetchPengguna()
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        _showToast('Gagal: $e', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        centerTitle: true,
        title: const Text('Edit Profil Pengguna', 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Color(0xFFF0F4F5),
                  child: Icon(Icons.person_outline, size: 40, color: Color(0xFF8FAFB6)),
                ),
              ),
              const SizedBox(height: 30),
              
              _labelForm("Alamat Email"),
              _buildTextField(
                controller: _emailController, 
                hint: "Masukkan email", 
                icon: Icons.alternate_email
              ),
              
              const SizedBox(height: 20),
              _labelForm("Ganti Kata Sandi (Opsional)"),
              _buildPasswordField(),
              
              const SizedBox(height: 20),
              _labelForm("Jenis Akses / Role"),
              _buildDropdown(),
              
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      text: 'Batal',
                      color: Colors.grey.shade200,
                      textColor: Colors.black54,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _actionButton(
                      text: _isLoading ? '...' : 'Simpan',
                      color: const Color(0xFF8FAFB6),
                      textColor: Colors.white,
                      onTap: _isLoading ? null : _updatePengguna,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelForm(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 5),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF5A7A81))),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8FAFB6), size: 20),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8FAFB6), size: 20),
        hintText: "Isi jika ingin ubah sandi",
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey, size: 20),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _jenisAkun,
          isExpanded: true,
          items: const ['Peminjam', 'Petugas', 'Admin'].map((String val) {
            return DropdownMenuItem(value: val, child: Text(val));
          }).toList(),
          onChanged: (val) => setState(() => _jenisAkun = val!),
        ),
      ),
    );
  }

  Widget _actionButton({required String text, required Color color, required Color textColor, required VoidCallback? onTap}) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: onTap,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}