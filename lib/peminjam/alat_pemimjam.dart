// Abaikan warning tertentu dari analyzer
// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/peminjam/detail.dart';

/// Halaman utama daftar alat
class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Client Supabase
  final SupabaseClient supabase = Supabase.instance.client;

  // Data alat (asli dari database)
  List<Map<String, dynamic>> _alat = [];

  // Status loading
  bool _isLoading = true;

  // Kategori filter
  final List<String> _categories = ['Semua', 'Laptop', 'Proyektor', 'Kamera', 'Mouse'];
  int _selectedCategory = 0;

  // Controller search
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAlat(); // Ambil data saat halaman dibuka
  }

  /// Ambil data alat dari Supabase
  Future<void> _fetchAlat() async {
    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from('alat')
          .select()
          .order('nama_alat');

      _alat = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      _showError('Gagal memuat data: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  /// Filter data berdasarkan search & kategori
  List<Map<String, dynamic>> get _filteredAlat {
    final query = _searchCtrl.text.toLowerCase();
    final category = _categories[_selectedCategory].toLowerCase();

    return _alat.where((item) {
      final nama = (item['nama_alat'] ?? '').toString().toLowerCase();
      final kat = (item['kategori'] ?? '').toString().toLowerCase();

      final cocokSearch = nama.contains(query);
      final cocokKategori = category == 'semua' || kat == category;

      return cocokSearch && cocokKategori;
    }).toList();
  }

  /// SnackBar error
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFBFD6DB),
      body: Column(
        children: [
          _header(),
          SizedBox(height: 15),
          _categoryList(),
          SizedBox(height: 15),
          Expanded(child: _content()),
        ],
      ),
    );
  }

  /// Header + search
  Widget _header() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 60, 25, 25),
      decoration: BoxDecoration(
        color: Color(0xFF8FAFB6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF8FAFB6)),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hallo, Selamat datang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Rara Aramita Azura', style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari alat pinjamanmu...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// List kategori horizontal
  Widget _categoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 15),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;

          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? Color(0xFF53666D) : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _categories[i],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Konten utama
  Widget _content() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_filteredAlat.isEmpty) {
      return Center(child: Text('Alat tidak ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: _fetchAlat,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filteredAlat.length,
        itemBuilder: (_, i) => _alatCard(_filteredAlat[i]),
      ),
    );
  }

  /// Card alat
  Widget _alatCard(Map<String, dynamic> alat) {
    final tersedia = alat['status'] == 'Tersedia';

    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          // Foto
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: alat['foto_url'] != null
                ? Image.network(
                    alat['foto_url'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.broken_image),
                  )
                : Icon(Icons.inventory, size: 70),
          ),
          SizedBox(width: 15),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alat['nama_alat'] ?? '-',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(alat['kategori'] ?? '-', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 5),
                Chip(
                  label: Text(
                    alat['status'],
                    style: TextStyle(
                      color: tersedia ? Colors.green : Colors.red,
                      fontSize: 11,
                    ),
                  ),
                  backgroundColor: tersedia ? Colors.green[50] : Colors.red[50],
                ),
              ],
            ),
          ),

          // Tombol detail
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF8FAFB6)),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailAlatPage(alat: alat),
              ),
            ),
            child: Text('Detail', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
