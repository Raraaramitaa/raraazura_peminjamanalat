import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/petugas/kembalii/pengembalian.dart';
import 'status.dart'; 
// ignore: unused_import
import 'pengembalian.dart'; // Import file pengembalian

class DashboardPetugasPage extends StatefulWidget {
  const DashboardPetugasPage({super.key});

  @override
  State<DashboardPetugasPage> createState() => _DashboardPetugasPageState();
}

class _DashboardPetugasPageState extends State<DashboardPetugasPage> {
  // Variabel untuk melacak halaman mana yang sedang aktif
  int _currentIndex = 0;

  // List semua halaman yang bisa diakses dari Navbar secara lengkap
  final List<Widget> _pages = [
    const BerandaContent(),     // Index 0
    const StatusPage(),         // Index 1
    const PengembalianPage(),   // Index 2 (Sudah dihubungkan ke pengembalian.dart)
    const Center(child: Text("Halaman Laporan")), // Index 3
    const LogoutPage(),         // Index 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      // Body akan berubah otomatis sesuai _currentIndex
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update index saat ikon diklik
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A6A70),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_return), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

// --- Komponen Konten Beranda ---
class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Biru dengan Profil
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(120),
                bottomRight: Radius.circular(120),
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text('Petugas', style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 8),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFF8FAFB6)),
                ),
                SizedBox(height: 8),
                Text(
                  'Rara Aramita Azura',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Menu Cards (Permintaan & Pengembalian)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    _menuCard(icon: Icons.assignment, text: 'Permintaan\nPeminjaman'),
                    const SizedBox(width: 15),
                    _menuCard(icon: Icons.trending_up, text: 'Pengembalian\nbarang'),
                  ],
                ),
                const SizedBox(height: 15),
                // Info Cards (Stok)
                Row(
                  children: [
                    _infoCard(icon: Icons.storage, value: '15', label: 'Tersedia'),
                    const SizedBox(width: 15),
                    _infoCard(icon: Icons.assignment_turned_in, value: '4', label: 'Dipinjam'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 25),
          
          // Daftar Peminjaman Alat
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daftar Peminjaman alat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  _peminjamanItem(inisial: 'R', nama: 'Raraazura', barang: 'Sonic Camera', warna: Colors.green),
                  _peminjamanItem(inisial: 'A', nama: 'Azurarara', barang: 'Nikon Camera', warna: Colors.blue),
                  _peminjamanItem(inisial: 'Z', nama: 'Zuraarmita', barang: 'Mouse', warna: Colors.purple),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // Fungsi Helper untuk Card Menu
  Widget _menuCard({required IconData icon, required String text}) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 35, color: const Color(0xFF8FAFB6)),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper untuk Card Info
  Widget _infoCard({required IconData icon, required String value, required String label}) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF8FAFB6)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper untuk Item List Peminjaman
  Widget _peminjamanItem({required String inisial, required String nama, required String barang, required Color warna}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: warna,
            child: Text(inisial, style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(barang, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8FAFB6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text('Proses', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}