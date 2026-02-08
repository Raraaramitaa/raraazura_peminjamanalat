import 'package:flutter/material.dart';
import 'package:peminjam_alat/alat/alat.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';

// ✅ TAMBAHAN: import halaman riwayat
// ignore: unused_import
import 'package:peminjam_alat/riwayat/riwayat.dart';

// ignore: unused_import
import 'package:peminjam_alat/admin/logout.dart';

// ignore: unused_import
import 'package:peminjam_alat/kategori/kategori.dart' as kat;

class DashboardAdminPage extends StatelessWidget {
  const DashboardAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      body: Column(
        children: [
          // ================= HEADER SECTION =================
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ===== Judul + Logout =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hi, Selamat Datang',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LogoutPage(),
                              ),
                            );
                          },
                        ),
                      ],
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
                            child: Icon(Icons.person,
                                color: Colors.black, size: 30),
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
                              style: TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
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
                  // Row 1
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

                  // Row 2
                  Row(
                    children: [
                      _buildSmallStatCard(
                        context,
                        title: 'Sedang Dipinjam',
                        value: '6',
                        icon: Icons.check_circle_outline,
                        target: const AlatPage(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Row 3
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

                  // ================= GRAFIK =================
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
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        _buildChartArea(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const PenggunaPage()));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AlatPage()));
            } else if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const kat.KategoriPage(),
                ),
              );
            } else if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Kat_RiwayatPage(),
                ),
              );
            } else if (index == 5) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LogoutPage()));
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Pengguna'),
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined), label: 'Produk'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined), label: 'Kategori'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_return_outlined), label: 'Akun'),
          ],
        ),
      ),
    );
  }

  // ================= HELPER WIDGETS (UTUH) =================

  Widget _buildStatCard(BuildContext context,
      {required String title,
      required String value,
      required String subtitle,
      required IconData icon,
      required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
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
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 10),
              Text(value,
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style:
                      const TextStyle(fontSize: 11, color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
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
                child: Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 13)),
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

  Widget _buildSmallStatCard(BuildContext context,
      {required String title,
      required String value,
      required IconData icon,
      required Widget target}) {
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (_) => target)),
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
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(value,
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Icon(icon, size: 18, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartArea() {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
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
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    9,
                    (index) =>
                        Container(height: 1, color: Colors.black12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(80),
                      _buildBar(130),
                      _buildBar(70),
                      _buildBar(100),
                      _buildBar(40),
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

// ================== PERBAIKAN ERROR LINE 237 ==================
// ignore: camel_case_types
class Kat_RiwayatPage extends StatelessWidget {
  const Kat_RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Halaman Riwayat',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
