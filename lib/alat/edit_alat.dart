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
  String? _selectedKategori;
  
  List<String> _kategoriList = []; 
  // Daftar status yang tersedia di database
  final List<String> _statusList = ["Ada", "Dipinjam", "Tersedia"]; 
  
  bool _isLoading = false;
  bool _isFetchingKategori = true;

  @override
  void initState() {
    super.initState();
    
    // 1. Inisialisasi Controller (Null Safety)
    _namaController = TextEditingController(text: widget.data['nama_alat']?.toString() ?? "");
    
    // 2. Deteksi nama kolom stok (stok atau stok_alat)
    var stokValue = widget.data['stok'] ?? widget.data['stok_alat'] ?? "0";
    _stokController = TextEditingController(text: stokValue.toString());
    
    // 3. Validasi Status agar tidak error Assertion
    String? initialStatus = widget.data['status']?.toString();
    if (_statusList.contains(initialStatus)) {
      _selectedStatus = initialStatus;
    } else {
      _selectedStatus = null; 
    }
    
    // 4. Inisialisasi Kategori awal
    _selectedKategori = widget.data['kategori']?.toString();
    
    _fetchKategoriList();
  }

  Future<void> _fetchKategoriList() async {
    try {
      // Ambil data kategori dari tabel 'kategori'
      final response = await supabase.from('kategori').select('nama_kategori');
      
      final List<String> fetchedKategori = (response as List)
          .map((item) => item['nama_kategori'].toString())
          .toList();

      if (mounted) {
        setState(() {
          _kategoriList = fetchedKategori;

          // PERBAIKAN: Tambahkan "Mouse" secara manual jika tidak ada di database
          if (!_kategoriList.contains("Mouse")) {
            _kategoriList.add("Mouse");
          }

          // Tambahkan kategori yang sedang dipilih ke list jika belum terdaftar
          if (_selectedKategori != null && !_kategoriList.contains(_selectedKategori)) {
            _kategoriList.add(_selectedKategori!);
          }
          
          _isFetchingKategori = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch Kategori: $e");
      if (mounted) {
        setState(() {
          // Jika error, setidaknya list berisi "Mouse" agar tetap bisa dipilih
          _kategoriList = ["Mouse"];
          _isFetchingKategori = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  Future<void> _updateAlat() async {
    if (_namaController.text.trim().isEmpty) {
      _showSnackBar("Nama alat tidak boleh kosong", Colors.orange);
      return;
    }

    // Ambil ID secara fleksibel (id atau id_alat)
    final dynamic idAlat = widget.data['id'] ?? widget.data['id_alat']; 
    final String primaryKeyName = widget.data.containsKey('id') ? 'id' : 'id_alat';
    
    if (idAlat == null) {
      _showSnackBar("Gagal: ID Alat tidak ditemukan!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> updateData = {
        'nama_alat': _namaController.text.trim(),
        'status': _selectedStatus,
        'kategori': _selectedKategori,
      };

      // Handle perbedaan nama kolom stok
      if (widget.data.containsKey('stok_alat')) {
        updateData['stok_alat'] = int.tryParse(_stokController.text) ?? 0;
      } else {
        updateData['stok'] = int.tryParse(_stokController.text) ?? 0;
      }

      await supabase
          .from('alat')
          .update(updateData)
          .eq(primaryKeyName, idAlat);

      if (mounted) {
        _showSnackBar("Perubahan berhasil disimpan!", Colors.green);
        Navigator.pop(context, true); 
      }
    } on PostgrestException catch (error) {
       _showSnackBar("Database Error: ${error.message}", Colors.red);
    } catch (e) {
       _showSnackBar("Sistem Error: $e", Colors.red);
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
        title: const Text("EDIT DATA ALAT", 
          style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Putih di bagian bawah
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
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: const AssetImage('assets/images/camera.png'), 
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(_namaController.text,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 25),

                  _buildTextField("Nama Alat", _namaController),
                  
                  _buildLabel("Status"),
                  _buildDropdown(_selectedStatus, _statusList, (v) => setState(() => _selectedStatus = v)),
                  
                  const SizedBox(height: 15),
                  _buildTextField("Stok", _stokController, isNumber: true),
                  
                  _buildLabel("Kategori"),
                  _buildDropdownKategori(),

                  const SizedBox(height: 40),

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

  Widget _buildLabel(String label) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8.0),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          onChanged: (v) { if (label == "Nama Alat") setState(() {}); },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown(String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null, 
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
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
          : DropdownButton<String>(
              value: _kategoriList.contains(_selectedKategori) ? _selectedKategori : null,
              isExpanded: true,
              hint: const Text("Pilih Kategori"),
              items: _kategoriList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedKategori = v),
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