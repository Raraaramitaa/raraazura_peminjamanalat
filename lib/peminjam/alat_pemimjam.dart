// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:peminjam_alat/peminjam/kembali/kembali.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import 'kembali.dart'; // Import halaman kembali untuk menghubungkan data

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Inisialisasi Supabase Client
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> allAlat = [];
  List<Map<String, dynamic>> filteredAlat = [];
  bool isLoading = true;

  // Daftar Kategori (Pastikan teks ini sesuai dengan isi kolom 'kategori' di tabel Supabase)
  final List<String> categories = ['Semua', 'Laptop', 'Proyektor', 'Kamera', 'Mouse'];
  int selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataAlat();
  }

  // ================= FETCH DATA DARI SUPABASE =================
  Future<void> fetchDataAlat() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      // 1. Mengambil data dari tabel 'alat'
      // 2. Select '*' untuk mengambil semua kolom (id, nama_alat, kategori, status, foto_url, dll)
      final data = await supabase
          .from('alat')
          .select()
          .order('nama_alat', ascending: true);

      if (mounted) {
        setState(() {
          allAlat = List<Map<String, dynamic>>.from(data);
          _applyFilters(); // Sinkronkan dengan pencarian/kategori yang aktif
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Koneksi Supabase: $e");
      if (mounted) {
        setState(() => isLoading = false);
        _showErrorSnackBar("Gagal memuat data dari tabel 'alat'. Periksa koneksi atau nama tabel.");
      }
    }
  }

  // ================= LOGIKA FILTER & PENCARIAN =================
  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final selectedCat = categories[selectedCategoryIndex].toLowerCase();

    setState(() {
      filteredAlat = allAlat.where((item) {
        // Mengambil data string dengan proteksi null safety
        final name = (item['nama_alat'] ?? '').toString().toLowerCase();
        final category = (item['kategori'] ?? '').toString().toLowerCase();

        bool matchQuery = name.contains(query);
        bool matchCategory = selectedCat == 'semua' || category == selectedCat;

        return matchQuery && matchCategory;
      }).toList();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Column(
        children: [
          // HEADER AREA
          Container(
            padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF8FAFB6), size: 30),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hallo, Selamat datang',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        Text('Rara Aramita Azura', style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Cari alat pinjamanmu...',
                      prefixIcon: Icon(Icons.search, color: Color(0xFF8FAFB6)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // HORIZONTAL CATEGORIES
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                      _applyFilters();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF53666D) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // LIST ALAT DARI SUPABASE
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDataAlat,
              color: Color(0xFF8FAFB6),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredAlat.isEmpty
                      ? ListView(children: const [
                          Center(child: Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Text("Alat tidak tersedia atau tidak ditemukan."),
                          ))
                        ])
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredAlat.length,
                          itemBuilder: (context, index) => _buildProductCard(filteredAlat[index]),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET KARTU PRODUK (MAPPING DATA DARI TABEL SUPABASE)
  Widget _buildProductCard(Map<String, dynamic> item) {
    // Pastikan nama di dalam ['...'] sama persis dengan nama kolom di tabel alat Supabase Anda
    final String name = item['nama_alat'] ?? 'Nama Tidak Ada';
    final String category = item['kategori'] ?? 'Lainnya';
    final String status = (item['status'] ?? 'Tersedia').toString();
    final String? fotoUrl = item['foto_url'];
    
    bool isAvailable = status.toLowerCase() == 'tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Gambar Produk
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (fotoUrl != null && fotoUrl.isNotEmpty)
                  ? Image.network(
                      fotoUrl, 
                      fit: BoxFit.cover, 
                      errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: Colors.grey)
                    )
                  : Icon(Icons.inventory_2, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          // Informasi Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(category, style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                    status, 
                    style: TextStyle(
                      color: isAvailable ? Colors.green : Colors.red, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 10
                    )
                  ),
                ),
              ],
            ),
          ),
          // Tombol Hubungkan ke KembaliPage
          ElevatedButton(
            onPressed: () {
              // Menghubungkan data produk ini ke halaman KembaliPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KembaliPage(
                    dataPeminjaman: {
                      'nama_alat': name,
                      'tanggal_pinjam': '10 Februari 2026', // Contoh data statis
                      'tanggal_kembali': '17 Februari 2026',
                      'total_alat': 1,
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8FAFB6), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            child: Text("Detail", style: TextStyle(color: Colors.white, fontSize: 11)),
          )
        ],
      ),
    );
  }
}