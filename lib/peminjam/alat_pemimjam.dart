// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlatPage extends StatefulWidget {
  const AlatPage({super.key});

  @override
  State<AlatPage> createState() => _AlatPageState();
}

class _AlatPageState extends State<AlatPage> {
  // Inisialisasi Supabase Client
  final SupabaseClient supabase = Supabase.instance.client;

  // State Management
  List<Map<String, dynamic>> allAlat = [];
  List<Map<String, dynamic>> filteredAlat = [];
  bool isLoading = true;

  final List<String> categories = ['Semua', 'Laptop', 'Proyektor', 'Kamera', 'Mouse'];
  int selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataAlat();
  }

  // ================= DATA FETCHING (DARI SUPABASE) =================
  Future<void> fetchDataAlat() async {
    setState(() => isLoading = true);
    try {
      // Mengambil data dari tabel 'alat' di Supabase
      // Pastikan nama tabel di Supabase Anda adalah 'alat'
      final data = await supabase
          .from('alat')
          .select()
          .order('nama_alat', ascending: true);

      setState(() {
        allAlat = List<Map<String, dynamic>>.from(data);
        // Jalankan filter pertama kali untuk sinkronisasi kategori 'Semua'
        _applyFilters(); 
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================= LOGIKA FILTER (PENCARIAN & KATEGORI) =================
  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final selectedCat = categories[selectedCategoryIndex];

    setState(() {
      filteredAlat = allAlat.where((item) {
        final name = (item['nama_alat'] ?? '').toString().toLowerCase();
        final category = (item['kategori'] ?? '').toString();

        bool matchQuery = name.contains(query);
        bool matchCategory = selectedCat == 'Semua' || category == selectedCat;

        return matchQuery && matchCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Column(
        children: [
          // ================= HEADER AREA =================
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
                  children: const [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Color(0xFF8FAFB6), size: 30),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hallo, Selamat datang',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Rara Aramita Azura',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => _applyFilters(),
                    decoration: InputDecoration(
                      hintText: 'Cari alat pinjamanmu...',
                      hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: Icon(Icons.search, color: Colors.black54),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= CATEGORY LIST =================
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                        _applyFilters();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF8FAFB6) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 25),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Alat Tersedia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // ================= PRODUCT LIST (DYNAMIS) =================
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchDataAlat,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredAlat.isEmpty
                      ? const Center(
                          child: Text(
                            "Alat tidak ditemukan atau data kosong",
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredAlat.length,
                          itemBuilder: (context, index) {
                            final item = filteredAlat[index];
                            return _buildProductCard(item);
                          },
                        ),
            ),
          ),
        ],
      ),

      // ================= BOTTOM NAV BAR =================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFBFD6DB),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        currentIndex: 1, // Fokus pada tab Alat
        onTap: (index) {
          // Tambahkan logika navigasi antar halaman di sini
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Pinjam'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    // Pastikan nilai status sensitif terhadap case di database (Tersedia / tersedia)
    bool isAvailable = (item['status']?.toString().toLowerCase() ?? '') == 'tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk dari URL Supabase Storage atau link eksternal
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item['foto_url'] != null && item['foto_url'] != ""
                  ? Image.network(
                      item['foto_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    )
                  : const Icon(Icons.inventory_2, size: 40, color: Colors.black45),
            ),
          ),
          const SizedBox(width: 15),
          // Info Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama_alat'] ?? 'Tanpa Nama',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  item['kategori'] ?? 'Tanpa Kategori',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                // Badge Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvailable 
                        ? Colors.green.withOpacity(0.1) 
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isAvailable ? Icons.check_circle : Icons.cancel,
                        color: isAvailable ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item['status'] ?? 'Tidak Diketahui',
                        style: TextStyle(
                          color: isAvailable ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Tombol Detail
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke halaman detail dengan membawa data 'item'
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FAFB6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Lihat Detail', style: TextStyle(fontSize: 11)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}