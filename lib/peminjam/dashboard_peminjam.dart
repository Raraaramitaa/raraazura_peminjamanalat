import 'package:flutter/material.dart';

// Jika AlatPage ada di file berbeda, pastikan import ini benar:
// import 'alat.dart'; 

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  // Variable untuk melacak halaman yang aktif
  int _selectedIndex = 0;

  // List halaman yang akan ditampilkan di dalam body
  final List<Widget> _pages = [
    const BerandaContent(), // Index 0
    const AlatPage(),       // Index 1 (Ini halaman Alat yang Anda minta)
    const Center(child: Text('Halaman Pinjam')),  // Index 2
    const Center(child: Text('Halaman Kembali')), // Index 3
    const Center(child: Text('Halaman Profil')),  // Index 4
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      // Body akan berubah sesuai index navbar
      body: _pages[_selectedIndex],
      
      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF8FAFB6),
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Pinjam'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_return_outlined), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

// ================= HALAMAN BERANDA (KONTEN UTAMA) =================
class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF8FAFB6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black54),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hallo, Selamat datang', style: TextStyle(color: Colors.white, fontSize: 14)),
                      SizedBox(height: 4),
                      Text('Rara Aramita Azura', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Total Peminjaman Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Peminjaman', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      value: 0.6,
                      minHeight: 8,
                      backgroundColor: Color(0xFFE0E0E0),
                      valueColor: AlwaysStoppedAnimation(Color(0xFF8FAFB6)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status Row
            Row(
              children: [
                _buildStatusBox(const Color(0xFF28A745), Icons.check_circle, '1 Selesai'),
                const SizedBox(width: 12),
                _buildStatusBox(const Color(0xFFDC3545), Icons.warning_rounded, '2 Terlambat'),
              ],
            ),
            const SizedBox(height: 20),

            // Section Peminjaman Terakhir
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status Peminjaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.assignment, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 12),
            _itemPeminjaman(title: 'Nikon Camera', subtitle: 'Kembali dalam: 5 hari'),
            _itemPeminjaman(title: 'Laptop', subtitle: 'Kembali dalam: 5 hari'),
            _itemPeminjaman(title: 'USB', subtitle: 'Kembali dalam: 5 hari'),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatusBox(Color color, IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 6),
            Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  static Widget _itemPeminjaman({required String title, required String subtitle}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 55, height: 55,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFDDE7EA), borderRadius: BorderRadius.circular(20)),
            child: const Text('Di Pinjam', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

// ================= HALAMAN ALAT (YANG DIMASUKKAN KE NAVBAR) =================
class AlatPage extends StatelessWidget {
  const AlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Khusus Alat
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF8FAFB6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daftar Alat', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Cari dan temukan alat yang kamu butuhkan', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
        
        // List Alat (Contoh)
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.inventory, size: 40, color: Color(0xFF8FAFB6)),
                  title: Text('Nama Alat #${index + 1}'),
                  subtitle: const Text('Tersedia: 5 Unit'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}