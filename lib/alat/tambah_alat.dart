import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahAlatPage extends StatefulWidget {
  final File? imageFile; // Tipe data harus File? (boleh null)

  // HAPUS kata 'const' di depan TambahAlatPage di bawah ini:
  const TambahAlatPage({super.key, this.imageFile}); 

  @override
  State<TambahAlatPage> createState() => _TambahAlatPageState();
}

class _TambahAlatPageState extends State<TambahAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  final TextEditingController namaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();

  String? selectedStatus;
  String? selectedKategori;
  bool _isLoading = false;

  final List<String> statusList = ["Ada", "Dipinjam"];
  final List<String> kategoriList = ["Laptop", "Proyektor", "Camera", "Mouse"];

  @override
  void dispose() {
    namaController.dispose();
    stokController.dispose();
    super.dispose();
  }

  // ================= SIMPAN DATA =================
  Future<void> _saveData() async {
    // 1. Validasi Input Lokal
    if (namaController.text.trim().isEmpty ||
        stokController.text.trim().isEmpty ||
        selectedStatus == null ||
        selectedKategori == null) {
      _showSnackBar("Harap isi semua kolom!", Colors.orange);
      return;
    }

    final int? stok = int.tryParse(stokController.text.trim());
    if (stok == null) {
      _showSnackBar("Stok harus berupa angka", Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Proses Insert ke Supabase
      // Pastikan nama tabel adalah 'alat'
      await supabase.from('alat').insert({
        'nama_alat': namaController.text.trim(),
        'stok': stok,
        'status': selectedStatus,
        'kategori': selectedKategori, 
      });

      if (!mounted) return;

      _showSnackBar("Alat berhasil ditambahkan!", Colors.green);
      
      // Menunggu sebentar agar user bisa melihat snackbar sebelum pindah halaman
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      // Navigator.pop(context, true) mengirimkan nilai 'true' 
      // agar halaman sebelumnya tahu ada data baru dan bisa melakukan refresh (fetch ulang)
      Navigator.pop(context, true); 

    } on PostgrestException catch (error) {
      debugPrint("DB ERROR: ${error.message}");
      if (!mounted) return;
      
      // Pesan khusus jika kolom tidak ditemukan di Supabase
      String pesan = "Database Error: ${error.message}";
      if (error.message.contains("column") && error.message.contains("not found")) {
        pesan = "Kolom tidak ditemukan! Pastikan di tabel 'alat' ada kolom: nama_alat, stok, status, kategori";
      }

      _showSnackBar(pesan, Colors.red);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar("Terjadi kesalahan sistem: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: warna,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        title: const Text("TAMBAH ALAT", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FAFB6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.white, thickness: 2),
                      const SizedBox(height: 20),

                      _buildLabel("Nama Alat"),
                      _buildTextField(namaController, "Masukan nama alat", isNumber: false),

                      _buildLabel("Stok"),
                      _buildTextField(stokController, "Masukan stok alat", isNumber: true),

                      _buildLabel("Status"),
                      _buildDropdown(
                        value: selectedStatus,
                        hint: "Pilih Status",
                        items: statusList,
                        onChanged: (val) => setState(() => selectedStatus = val),
                      ),

                      _buildLabel("Kategori"),
                      _buildDropdown(
                        value: selectedKategori,
                        hint: "Pilih kategori",
                        items: kategoriList,
                        onChanged: (val) => setState(() => selectedKategori = val),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              label: "Batal",
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildActionButton(
                              label: _isLoading ? "Tunggu..." : "Simpan",
                              color: const Color(0xFFBFD6DB),
                              textColor: Colors.black,
                              onPressed: _isLoading ? () {} : _saveData,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ================= WIDGET HELPER =================
  Widget _buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 5),
          child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint, {required bool isNumber}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDropdown({required String? value, required String hint, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 14)),
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, required Color color, required Color textColor, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}