import 'package:flutter/material.dart';
import 'package:peminjam_alat/alat/alat.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB), // Latar belakang abu-abu kebiruan
      body: Column(
        children: [
          // ================= HEADER SECTION =================
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6), // Warna Teal Header
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 20),
              child: Column(
                children: [
                  const Text(
                    'Hi, Selamat Datang',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26, width: 1),
                        ),
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFD9D9D9),
                          child: Icon(Icons.person, color: Colors.black, size: 30),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rara Aramita Azura',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ================= SCROLLABLE CONTENT =================
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Row 1: Data Peminjam (Besar) & Data Petugas (Ikon)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatCard(
                        context,
                        title: 'Data Peminjam',
                        value: '25',
                        subtitle: 'Total Peminjam',
                        icon: Icons.groups_rounded,
                        target: const PenggunaPage(),
                      ),
                      const SizedBox(width: 15),
                      _buildIconCard(
                        context,
                        title: 'Data Petugas',
                        icon: Icons.badge_outlined,
                        target: const PenggunaPage(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Row 2: Sedang Dipinjam & Kotak Kosong (Sesuai Layout Gambar)
                  Row(
                    children: [
                      _buildSmallStatCard(
                        context,
                        title: 'Sedang Dipinjam',
                        value: '6',
                        icon: Icons.check_circle_outline,
                        target: const AlatPage(),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F3F3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Row 3: Tersedia & Spacer
                  Row(
                    children: [
                      _buildSmallStatCard(
                        context,
                        title: 'Tersedia',
                        value: '10',
                        icon: Icons.inventory_2_outlined,
                        target: const AlatPage(),
                      ),
                      const SizedBox(width: 15),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ================= GRAFIK PEMINJAMAN =================
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Grafik Peminjaman Bulan Ini',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildChartArea(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Padding bawah agar tidak tertutup navbar
                ],
              ),
            ),
          ),
        ],
      ),
      // ================= BOTTOM NAVIGATION BAR =================
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
          currentIndex: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PenggunaPage()));
            } else if (index == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AlatPage()));
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
            BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Peminjaman'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment_return_outlined), label: 'Pengembalian'),
          ],
        ),
      ),
    );
  }

  // 1. Widget Kartu Statistik Utama (Data Peminjam)
  Widget _buildStatCard(BuildContext context,
      {required String title,
      required String value,
      required String subtitle,
      required IconData icon,
      required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F3F3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.black),
              const SizedBox(height: 5),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  // 2. Widget Kartu Ikon (Data Petugas)
  Widget _buildIconCard(BuildContext context,
      {required String title, required IconData icon, required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
        child: Container(
          height: 160,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F3F3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ),
              const Spacer(),
              Icon(icon, size: 70, color: Colors.black54),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Widget Kartu Kecil (Sedang Dipinjam / Tersedia)
  Widget _buildSmallStatCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F3F3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black12),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(value, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Positioned(right: 0, top: 0, child: Icon(icon, size: 18, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  // 4. Bagian Grafik Batang dengan Grid
  Widget _buildChartArea() {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Y-Axis Labels (Angka Samping)
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('40', style: TextStyle(fontSize: 10)),
              Text('35', style: TextStyle(fontSize: 10)),
              Text('30', style: TextStyle(fontSize: 10)),
              Text('25', style: TextStyle(fontSize: 10)),
              Text('20', style: TextStyle(fontSize: 10)),
              Text('15', style: TextStyle(fontSize: 10)),
              Text('10', style: TextStyle(fontSize: 10)),
              Text('5', style: TextStyle(fontSize: 10)),
              Text('0', style: TextStyle(fontSize: 10)),
            ],
          ),
          const SizedBox(width: 10),
          // Area Batang Grafik
          Expanded(
            child: Stack(
              children: [
                // Garis Grid Horizontal
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    9,
                    (index) => Container(height: 1, color: Colors.black12),
                  ),
                ),
                // Batang-batang Grafik
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(80),  // Mar
                      _buildBar(130), // Apr
                      _buildBar(70),  // Mei
                      _buildBar(100), // Jun
                      _buildBar(40),  // Jul
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

  // Helper Batang Grafik
  Widget _buildBar(double height) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF8FAFB6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(2, 0),
          )
        ],


        
      ),
    );
  }
}