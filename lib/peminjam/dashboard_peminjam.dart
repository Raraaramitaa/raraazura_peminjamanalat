import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/logout.dart'; // ✅ Pastikan path benar

class DashboardPeminjamPage extends StatefulWidget {
  const DashboardPeminjamPage({super.key});

  @override
  State<DashboardPeminjamPage> createState() => _DashboardPeminjamPageState();
}

class _DashboardPeminjamPageState extends State<DashboardPeminjamPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BerandaContent(),
    const AlatPage(),
    const Center(child: Text('Halaman Pinjam')),
    const Center(child: Text('Halaman Kembali')),
    const LogoutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB), // Warna latar belakang sesuai gambar
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFBFD6DB),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.view_in_ar_outlined), activeIcon: Icon(Icons.view_in_ar), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment), label: 'Pinjam'),
          BottomNavigationBarItem(icon: Icon(Icons.cached), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

// ================= HALAMAN BERANDA =================
class BerandaContent extends StatelessWidget {
  const BerandaContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // HEADER PROFILE (Header Melengkung Biru Abu-abu)
          Container(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25, bottom: 40),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Row(
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
                    Text('Hallo,Selamat datang',
                        style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Serif')),
                    Text('Rara Aramita Azura', style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // CARD TOTAL PEMINJAMAN
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Peminjaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const LinearProgressIndicator(
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

                // BARIS STATUS (HIJAU & MERAH)
                Row(
                  children: [
                    _buildStatusBox(const Color(0xFF28A745), Icons.check, '1 Selesai'),
                    const SizedBox(width: 20),
                    _buildStatusBox(const Color(0xFFEF4444), Icons.warning_amber_rounded, '2 Terlambat'),
                  ],
                ),

                const SizedBox(height: 30),

                // LIST STATUS PEMINJAMAN (KOTAK PUTIH)
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Status Peminjaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Icon(Icons.assignment_outlined, color: Color(0xFF4A90E2)),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildPeminjamanItem('Nicon Camera', 'Kembali dalam: 5 hari', Icons.camera_alt),
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
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPeminjamanItem(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.black54),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: const TextStyle(color: Colors.green, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFBCCDCF), borderRadius: BorderRadius.circular(15)),
            child: const Text('Di Pinjam', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ================= HALAMAN ALAT =================
class AlatPage extends StatelessWidget {
  const AlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HEADER ALAT DENGAN SEARCH BAR
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 60, bottom: 30, left: 25, right: 25),
          decoration: const BoxDecoration(
            color: Color(0xFF8FAFB6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(backgroundColor: Color(0xFFD9D9D9), child: Icon(Icons.person, color: Colors.black45)),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hallo,Selamat datang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Rara Aramita Azura', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari alat pinjamanmu..',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ],
          ),
        ),

        // FILTER KATEGORI (Laptop, Proyektor, dll)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip('Laptop', true),
                _buildFilterChip('Proyektor', false),
                _buildFilterChip('Kamera', false),
                _buildFilterChip('Mouse', false),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Align(alignment: Alignment.centerLeft, child: Text('Rekomendasi untuk kamu', style: TextStyle(fontWeight: FontWeight.bold))),
        ),

        // LIST ALAT
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                      width: 70, height: 70,
                      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.laptop, size: 40),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ASUS Zenbook S 16 (UM5606)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('Laptop', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 14),
                              SizedBox(width: 4),
                              Text('Tersedia', style: TextStyle(color: Colors.green, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8FAFB6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      child: const Text('Lihat Detail', style: TextStyle(fontSize: 10, color: Colors.white)),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8FAFB6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}