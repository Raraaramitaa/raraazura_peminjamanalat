import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahAlatPage extends StatefulWidget {
  const TambahAlatPage({super.key});

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua kolom!")),
      );
      return;
    }

    final int? stok = int.tryParse(stokController.text.trim());
    if (stok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok harus berupa angka")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Proses Insert ke Supabase
      // CATATAN: Pastikan 'nama_alat', 'stok', 'status', dan 'kategori' 
      // sudah ada di Table Editor Supabase Anda.
      await supabase.from('alat').insert({
        'nama_alat': namaController.text.trim(),
        'stok': stok,
        'status': selectedStatus,
        'kategori': selectedKategori, 
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alat berhasil ditambahkan!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } on PostgrestException catch (error) {
      // 3. Menangani error spesifik dari Database (seperti kolom hilang)
      debugPrint("DB ERROR: ${error.message}");
      if (!mounted) return;
      
      String pesanError = "Gagal di database: ${error.message}";
      if (error.code == 'PGRST204') {
        pesanError = "Kolom 'kategori' tidak ditemukan di database. Cek Table Editor Supabase Anda!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pesanError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      // 4. Menangani error umum (koneksi, null safety, dll)
      debugPrint("ERROR SYSTEM: $e");
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan sistem: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tambah Alat",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8FAFB6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Icon(
                            Icons.add_a_photo_outlined,
                            size: 60,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      const Divider(
                        color: Colors.white,
                        thickness: 5,
                        indent: 10,
                        endIndent: 10,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel("Nama"),
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

  // ================= WIDGET BANTUAN =================
  Widget _buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 5),
          child: Text(text,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
      );

  Widget _buildTextField(TextEditingController controller, String hint,
      {required bool isNumber}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint),
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label,
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16)),
    );
  }
}