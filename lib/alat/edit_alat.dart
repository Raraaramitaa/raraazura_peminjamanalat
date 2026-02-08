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
  late TextEditingController _statusController;
  
  String? _selectedKategori;
  List<String> _kategoriList = []; // Daftar kategori dinamis dari DB
  bool _isLoading = false;
  bool _isFetchingKategori = true;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang dikirim dari halaman alat
    _namaController = TextEditingController(text: widget.data['nama_alat']?.toString() ?? "");
    _stokController = TextEditingController(text: widget.data['stok']?.toString() ?? "0");
    _statusController = TextEditingController(text: widget.data['status']?.toString() ?? "");
    _selectedKategori = widget.data['kategori']?.toString();
    
    // Ambil daftar kategori dari database agar sinkron dengan kategori.dart
    _fetchKategoriList();
  }

  // FUNGSI MENGAMBIL KATEGORI DARI DATABASE (Sinkron dengan kategori.dart)
  Future<void> _fetchKategoriList() async {
    try {
      final data = await supabase.from('kategori').select('nama_kategori');
      final List<String> fetchedKategori = [];
      
      // ignore: unnecessary_null_comparison
      if (data != null) {
        for (var item in data) {
          fetchedKategori.add(item['nama_kategori'].toString());
        }
      }

      setState(() {
        _kategoriList = fetchedKategori;
        _isFetchingKategori = false;
        
        // Validasi jika kategori yang ada di data alat tidak ada di daftar kategori DB
        if (!_kategoriList.contains(_selectedKategori) && _kategoriList.isNotEmpty) {
          // Tetap simpan nilai lama jika memang ada, atau null jika tidak valid
        }
      });
    } catch (e) {
      debugPrint("Error fetch kategori: $e");
      if (mounted) {
        setState(() => _isFetchingKategori = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _stokController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  // FUNGSI SIMPAN PERUBAHAN KE SUPABASE
  Future<void> _updateAlat() async {
    // 1. Validasi Input Kosong
    if (_namaController.text.isEmpty || _selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama alat dan Kategori wajib diisi!')),
      );
      return;
    }

    // 2. Validasi ID (Penyebab Error pada gambar)
    final idAlat = widget.data['id'];
    if (idAlat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan: ID Alat tidak ditemukan!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Melakukan update ke database
      await supabase.from('alat').update({
        'nama_alat': _namaController.text,
        'stok': int.tryParse(_stokController.text) ?? 0,
        'status': _statusController.text,
        'kategori': _selectedKategori,
      }).eq('id', idAlat); // Menggunakan variabel idAlat yang sudah divalidasi tidak null

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan berhasil disimpan!'), backgroundColor: Colors.green),
        );
        // Kembali ke halaman sebelumnya dan kirim sinyal 'true' untuk refresh data
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      body: Stack(
        children: [
          // Background Putih Lengkung
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
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
                  const SizedBox(height: 30),
                  const Text("EDIT ALAT", 
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, letterSpacing: 2)
                  ),
                  const SizedBox(height: 20),
                  
                  // Avatar/Foto Produk
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: const AssetImage('assets/images/camera.png'), 
                          ),
                        ),
                        const Positioned(
                          bottom: 5,
                          right: 5,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFF7A98A0),
                            child: Icon(Icons.camera_alt, size: 18, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  Text(
                    _namaController.text,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 30),

                  // Form Input
                  _buildTextField("Nama Alat", _namaController),
                  _buildTextField("Status", _statusController),
                  _buildTextField("Stok", _stokController, isNumber: true),
                  
                  // Dropdown Kategori (Dinamis)
                  _buildDropdownField("Kategori"),

                  const SizedBox(height: 40),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBtn("Batal", const Color(0xFFBFD6DB), Colors.black, () => Navigator.pop(context)),
                      _buildBtn(
                        _isLoading ? "Loading..." : "Simpan", 
                        Colors.white, 
                        Colors.black, 
                        _isLoading ? null : _updateAlat
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
          onChanged: (v) {
            if (label == "Nama Alat") setState(() {}); 
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: DropdownButtonHideUnderline(
            child: _isFetchingKategori 
              ? const SizedBox(
                  height: 20,
                  child: Center(child: LinearProgressIndicator()),
                ) 
              : DropdownButton<String>(
                  hint: const Text("Pilih Kategori"),
                  value: _kategoriList.contains(_selectedKategori) ? _selectedKategori : null,
                  isExpanded: true,
                  items: _kategoriList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) {
                    setState(() => _selectedKategori = v);
                  },
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(String txt, Color bg, Color tc, VoidCallback? tap) {
    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        onPressed: tap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: Text(txt, style: TextStyle(color: tc, fontWeight: FontWeight.bold)),
      ),
    );
  }
}