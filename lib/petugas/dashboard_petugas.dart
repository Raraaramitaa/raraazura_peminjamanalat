import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardPetugasPage extends StatelessWidget {
  const DashboardPetugasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Kembali'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Petugas', style: TextStyle(color: Colors.white, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white, size: 16),
                        onPressed: () async {
                          await Supabase.instance.client.auth.signOut();
                          if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Color(0xFF8FAFB6)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Rara Aramita Azura',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
      ),
    );
  }

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