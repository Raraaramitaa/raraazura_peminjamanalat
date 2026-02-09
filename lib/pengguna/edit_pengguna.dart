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
    // Mengambil data lama dari widget.userData
    _emailController = TextEditingController(text: widget.userData['email']?.toString() ?? '');
    _passwordController = TextEditingController();
    
    // Set value awal dropdown berdasarkan data role di database
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

  Future<void> _updatePengguna() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email wajib diisi!')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await supabase.from('profiles').update({
        'email': _emailController.text.trim(),
        'role': _jenisAkun.toLowerCase(),
      }).eq('id', widget.userData['id']);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Perubahan berhasil disimpan'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Mengirim sinyal 'true' untuk refresh data di halaman daftar
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        title: const Text('Edit Pengguna', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Email Pengguna", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildTextField(controller: _emailController, hint: "Email", icon: Icons.email),
              
              const SizedBox(height: 20),
              const Text("Sandi (Opsional)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildPasswordField(),
              
              const SizedBox(height: 20),
              const Text("Role Akun", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDropdown(),
              
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      text: 'Batal',
                      color: Colors.grey.shade400,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildButton(
                      text: _isLoading ? '...' : 'Simpan',
                      color: const Color(0xFF8FAFB6),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8FAFB6)),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock, color: Color(0xFF8FAFB6)),
        hintText: "Isi jika ingin ganti sandi",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
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

  Widget _buildButton({required String text, required Color color, required VoidCallback? onTap}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}