// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'hapus_riwayat.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  int selectedTab = 0;

  final List<Map<String, dynamic>> items = [
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
    // Filter items berdasarkan tab yang dipilih
    List<Map<String, dynamic>> filteredItems;
    if (selectedTab == 1) {
      filteredItems = items.where((item) => item['status'] == 'Dipinjam').toList();
    } else if (selectedTab == 2) {
      filteredItems = items.where((item) => item['status'] == 'Selesai').toList();
    } else {
      filteredItems = items;
    }

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
          'Riwayat',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Search bar (UI only, filter belum diimplementasi)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
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
              onChanged: (value) {
                // Bisa ditambahkan fitur pencarian di sini jika perlu
                setState(() {});
              },
            ),
          ),

          // Tab filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _tabButton('Semua', 0),
                _tabButton('Dipinjam', 1),
                _tabButton('Dikembalikan', 2),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Daftar item riwayat
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('Tidak ada data'),
                  )
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

      // Bottom Navigation bar dengan tab Riwayat aktif (index 4)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        currentIndex: 4,
        onTap: (index) {
          // TODO: Implement navigasi ke halaman lain sesuai index bottom navbar
          // Contoh:
          // if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          // if (index == 1) Navigator.pushReplacementNamed(context, '/pengguna');
          // dst.
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pengguna'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Kategori'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _tabButton(String title, int index) {
    final isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.blueGrey : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _riwayatCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.devices, size: 28),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(item['subtitle']),
                Text(
                  item['date'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item['status'],
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const HapusRiwayatDialog(),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(color: Colors.red, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
