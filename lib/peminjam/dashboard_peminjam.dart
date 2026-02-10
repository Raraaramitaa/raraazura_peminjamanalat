// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

// ✅ PASTIKAN FILE-FILE DI BAWAH INI SUDAH ANDA BUAT DI PROJECT ANDA
// Jika nama file/folder berbeda, sesuaikan import-nya
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/peminjam/alat_pemimjam.dart';
import 'package:peminjam_alat/peminjam/pinjam/pinjam_alat.dart'; 
import 'package:peminjam_alat/peminjam/kembali/kembali.dart';
// ignore: unused_import
import 'package:peminjam_alat/peminjam/alat/alat.dart'; 

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _selectedIndex = 0;

  // List Halaman yang dipanggil berdasarkan Index Bottom Navigation
  final List<Widget> _pages = [
    const BerandaContent(),                // Index 0
    const AlatPage(),                      // Index 1
    const PinjamAlatPage(),                // Index 2
    const KembaliPage(dataPeminjaman: {}), // Index 3
    const LogoutPage(),                    // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB), 
      // Menggunakan IndexedStack agar state halaman (seperti scroll/input) tidak hilang saat pindah tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF8FAFB6), 
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), 
            activeIcon: Icon(Icons.home), 
            label: 'Beranda'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar_outlined), 
            activeIcon: Icon(Icons.view_in_ar), 
            label: 'Alat'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined), 
            activeIcon: Icon(Icons.assignment), 
            label: 'Pinjam'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cached), 
            label: 'Kembali'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), 
            activeIcon: Icon(Icons.settings), 
            label: 'Pengaturan'
          ),
        ],
      ),
    );
  }
}

// ================= HALAMAN BERANDA CONTENT =================
// Class ini dipisahkan agar kode Dashboard utama tetap ringkas
class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Profile
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Color(0xFFD9D9D9),
                  child: Icon(Icons.person, color: Colors.black45, size: 35),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hallo, Selamat datang',
                      style: TextStyle(
                        color: Colors.black87, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      'Rara Aramita Azura', 
                      style: TextStyle(color: Colors.white, fontSize: 14)
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Card Statistik Peminjaman
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Peminjaman', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          Text(
                            '3', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: 0.7,
                          minHeight: 12,
                          backgroundColor: Color(0xFFD9D9D9),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8FAFB6)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Baris Box Status (Selesai & Terlambat)
                Row(
                  children: [
                    _buildStatusBox(const Color(0xFF28A745), Icons.check, '1 Selesai'),
                    const SizedBox(width: 20),
                    _buildStatusBox(const Color(0xFFEF4444), Icons.warning_amber_rounded, '2 Terlambat'),
                  ],
                ),

                const SizedBox(height: 30),

                // List Status Peminjaman Aktif (Dummy Data)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status Peminjaman', 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                          ),
                          Icon(Icons.assignment_outlined, color: Color(0xFF4A90E2)),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildPeminjamanItem('Nikon Camera', 'Kembali dalam: 5 hari', Icons.camera_alt),
                      const Divider(),
                      _buildPeminjamanItem('Laptop', 'Kembali dalam: 5 hari', Icons.laptop_mac),
                      const Divider(),
                      _buildPeminjamanItem('USB', 'Kembali dalam: 5 hari', Icons.usb),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper untuk Box Status
  Widget _buildStatusBox(Color color, IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              label, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Item List Peminjaman
  Widget _buildPeminjamanItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.black12, 
              borderRadius: BorderRadius.circular(10)
            ),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  subtitle, 
                  style: const TextStyle(color: Colors.green, fontSize: 12)
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFBCCDCF), 
              borderRadius: BorderRadius.circular(15)
            ),
            child: const Text(
              'Di Pinjam', 
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      ),
    );
  }
}