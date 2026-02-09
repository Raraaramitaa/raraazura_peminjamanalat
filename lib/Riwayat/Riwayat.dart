// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:peminjam_alat/alat/alat.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/kategori/kategori.dart' as kat;
// Menambahkan 'as admin' untuk menghindari bentrok nama class (ambiguous_import)
import 'package:peminjam_alat/admin/dashboard_admin.dart' as admin; 

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int selectedTab = 0;
  String searchQuery = '';

  // Data Dummy Riwayat
  List<Map<String, dynamic>> items = [
    {
      'title': 'Roro Armita Azura',
      'subtitle': 'Laptop',
      'date': '10 Jun 2026 - 14 Jun 2026',
      'status': 'Dipinjam',
      'color': Colors.red
    },
    {
      'title': 'Clora Sunda Mulina',
      'subtitle': 'Proyektor Putih',
      'date': '5 Jun 2026 - 8 Jun 2026',
      'status': 'Selesai',
      'color': Colors.green
    },
    {
      'title': 'Elingga Sarawati',
      'subtitle': 'Mouse Tanpa Kabel',
      'date': '1 Jun 2026 - 5 Jun 2026',
      'status': 'Dipinjam',
      'color': Colors.red
    },
    {
      'title': 'Roroazura',
      'subtitle': 'Nikon Camera',
      'date': '6 Jun 2026 - 8 Jun 2026',
      'status': 'Selesai',
      'color': Colors.green
    },
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Filter berdasarkan Tab DAN Search Query secara bersamaan
    List<Map<String, dynamic>> filteredItems = items.where((item) {
      final matchesTab = (selectedTab == 0) ||
          (selectedTab == 1 && item['status'] == 'Dipinjam') ||
          (selectedTab == 2 && item['status'] == 'Selesai');

      final matchesSearch = item['title']
              .toLowerCase()
              .contains(searchQuery.toLowerCase()) ||
          item['subtitle'].toLowerCase().contains(searchQuery.toLowerCase());

      return matchesTab && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xffc9d6dc),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Riwayat Peminjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari nama atau alat...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Tab filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _tabButton('Semua', 0),
                _tabButton('Dipinjam', 1),
                _tabButton('Selesai', 2),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Daftar item riwayat
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('Tidak ada data riwayat'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _riwayatCard(item);
                    },
                  ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF8FAFB6),
          currentIndex: 4, // Index Riwayat
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const admin.DashboardAdminPage()));
            } else if (index == 1) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const PenggunaPage()));
            } else if (index == 2) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const AlatPage()));
            } else if (index == 3) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const kat.KategoriPage()));
            } else if (index == 5) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LogoutPage()));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
            BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0C3B5A) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _riwayatCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFBFD6DB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2, color: Color(0xFF0C3B5A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(item['subtitle'], style: const TextStyle(fontSize: 13)),
                Text(
                  item['date'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'],
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  _konfirmasiHapus(item);
                },
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _konfirmasiHapus(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                items.remove(item);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data riwayat dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}