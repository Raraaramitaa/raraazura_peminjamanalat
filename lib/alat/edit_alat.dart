// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAlatPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditAlatPage({super.key, required this.data});

  @override
  State<EditAlatPage> createState() => _EditAlatPageState();
}

class _EditAlatPageState extends State<EditAlatPage> {
  final supabase = Supabase.instance.client;
  
  late TextEditingController _namaController;
  late TextEditingController _stokController;
  
  String? _selectedStatus;
  int? _selectedKategoriId; 
  
  List<Map<String, dynamic>> _kategoriList = []; 
  final List<String> _statusList = ["Ada", "Dipinjam", "Tersedia"]; 
  
  bool _isLoading = false;
  bool _isFetchingKategori = true;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi data awal dari widget.data
    _namaController = TextEditingController(text: widget.data['nama_alat']?.toString() ?? "");
    
    // Penanganan stok yang lebih aman
    var stokValue = widget.data['stok'] ?? widget.data['stok_alat'] ?? 0;
    _stokController = TextEditingController(text: stokValue.toString());
    
    _selectedStatus = widget.data['status']?.toString();
    _selectedKategoriId = widget.data['id_kategori'];
    
    _fetchKategoriList();
  }

  Future<void> _fetchKategoriList() async {
    try {
      final response = await supabase.from('kategori').select('id_kategori, nama_kategori');
      if (mounted) {
        setState(() {
          _kategoriList = List<Map<String, dynamic>>.from(response);
          _isFetchingKategori = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Kategori: $e");
      if (mounted) setState(() => _isFetchingKategori = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  // --- FUNGSI UPDATE UTAMA ---
  Future<void> _updateAlat() async {
    // 1. Validasi Input
    if (_namaController.text.trim().isEmpty) {
      _showSnackBar("Nama alat tidak boleh kosong", Colors.orange);
      return;
    }

    // 2. Ambil ID Primer (Sesuaikan nama kolom di database kamu)
    final dynamic idAlat = widget.data['id_alat']; 
    
    if (idAlat == null) {
      _showSnackBar("Gagal: ID Alat tidak ditemukan!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 3. Persiapkan Data Update
      final Map<String, dynamic> updateData = {
        'nama_alat': _namaController.text.trim(),
        'status': _selectedStatus,
        'id_kategori': _selectedKategoriId,
        'stok': int.tryParse(_stokController.text) ?? 0,
      };

      // 4. Proses Update ke Supabase
      // Pastikan kolom 'id_alat' sesuai dengan Primary Key di tabel Supabase kamu
      await supabase
          .from('alat')
          .update(updateData)
          .eq('id_alat', idAlat);

      if (mounted) {
        _showSnackBar("✅ Perubahan berhasil disimpan!", Colors.green);
        
        // PENTING: Berikan delay sedikit agar user bisa melihat snackbar sebelum pindah
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Navigator.pop dengan nilai 'true' agar halaman sebelumnya tahu ada perubahan
        Navigator.pop(context, true); 
      }
    } on PostgrestException catch (error) {
        _showSnackBar("Database Error: ${error.message}", Colors.red);
    } catch (e) {
        _showSnackBar("Terjadi kesalahan sistem", Colors.red);
        debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String pesan, Color warna) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan), 
        backgroundColor: warna,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("EDIT DATA ALAT", 
          style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Decor
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.elliptical(400, 100)),
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Foto Alat
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (widget.data['foto_url'] != null && widget.data['foto_url'].toString().isNotEmpty) 
                        ? NetworkImage(widget.data['foto_url']) 
                        : const AssetImage('assets/images/camera.png') as ImageProvider, 
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(_namaController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 25),

                  // Form Inputs
                  _buildTextField("Nama Alat", _namaController),
                  
                  _buildLabel("Status"),
                  _buildDropdownStatus(),
                  
                  const SizedBox(height: 15),
                  _buildTextField("Stok", _stokController, isNumber: true),
                  
                  _buildLabel("Kategori"),
                  _buildDropdownKategori(),

                  const SizedBox(height: 40),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBtn("Batal", const Color(0xFFBFD6DB), Colors.black, () => Navigator.pop(context)),
                      _buildBtn(
                        _isLoading ? "Loading..." : "Simpan", 
                        const Color(0xFF4A6A70), 
                        Colors.white, 
                        _isLoading ? null : _updateAlat
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk UI yang lebih konsisten
  Widget _buildLabel(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8.0, top: 5),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2C3E50))),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      children: [
        _buildLabel(label),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          onChanged: (v) { if (label == "Nama Alat") setState(() {}); },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdownStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _statusList.contains(_selectedStatus) ? _selectedStatus : null,
          isExpanded: true,
          hint: const Text("Pilih Status"),
          items: _statusList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => setState(() => _selectedStatus = v),
        ),
      ),
    );
  }

  Widget _buildDropdownKategori() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: _isFetchingKategori 
          ? const SizedBox(height: 48, child: Center(child: CircularProgressIndicator(strokeWidth: 2))) 
          : DropdownButton<int>(
              value: _kategoriList.any((k) => k['id_kategori'] == _selectedKategoriId) ? _selectedKategoriId : null,
              isExpanded: true,
              hint: const Text("Pilih Kategori"),
              items: _kategoriList.map((kat) {
                return DropdownMenuItem<int>(
                  value: kat['id_kategori'] as int,
                  child: Text(kat['nama_kategori'].toString()),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedKategoriId = v),
            ),
      ),
    );
  }

  Widget _buildBtn(String txt, Color bg, Color tc, VoidCallback? tap) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.38,
      height: 50,
      child: ElevatedButton(
        onPressed: tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(txt, style: TextStyle(color: tc, fontWeight: FontWeight.bold)),
      ),
    );
  }
}