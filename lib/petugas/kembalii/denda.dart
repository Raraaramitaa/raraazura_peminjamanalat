import 'package:flutter/material.dart';
import 'validasi_pembayaran.dart';

class DendaPage extends StatelessWidget {
  const DendaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 60, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF53666D),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hallo Petugas',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                Icon(Icons.account_circle, size: 45, color: Colors.white70),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem('Pengembalian', false),
                _buildTabItem('Selesai', false),
                _buildTabItem('Denda', true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Card Item
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFB4C8CC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Aisyah Najwa',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'aisyah@gmail.com',
                            style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.more_vert),
                    ],
                  ),
                  const Divider(color: Colors.white, thickness: 1),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.laptop, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ASUS Zenbook S 16 (UM5606)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text('Tanggal Pinjam : 12/01/2026',
                                style: TextStyle(fontSize: 11)),
                            Text('Tanggal Kembali : 15/01/2026',
                                style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // TOMBOL VALIDASI
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                        ValidasiDialog.show(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8FAFB6),
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Validasi Pembayaran',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF53666D) : const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black45),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF53666D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home, 'Beranda'),
          _navIcon(Icons.history, 'Status'),
          _navIcon(Icons.assignment_return, 'Kembali'),
          _navIcon(Icons.bar_chart, 'Laporan'),
          _navIcon(Icons.settings, 'Pengaturan'),
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
      ],
    );
  }
}