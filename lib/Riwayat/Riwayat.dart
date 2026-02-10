// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:peminjam_alat/alat/alat.dart';
import 'package:peminjam_alat/auth/logout.dart';
import 'package:peminjam_alat/pengguna/pengguna.dart';
import 'package:peminjam_alat/kategori/kategori.dart' as kat;
import 'package:peminjam_alat/admin/dashboard_admin.dart' as admin;

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  int selectedTab = 0;
  String searchQuery = '';

  // ================= HAPUS RIWAYAT =================
  // ignore: unused_element
  Future<void> _hapusRiwayat(String id) async {
    try {
      await supabase.from('log_aktivitas').delete().eq('id', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Data riwayat berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f6f8),
      appBar: AppBar(
        backgroundColor: const Color(0xffc9d6dc),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Riwayat Peminjaman',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ================= SEARCH =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari nama atau alat...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0C3B5A)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ================= TAB =================
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

          // ================= STREAM LOG =================
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: supabase
                  .from('log_aktivitas')
                  .stream(primaryKey: ['id']), // ❗ TANPA ORDER
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada data riwayat 📭'));
                }

                final allLogs = snapshot.data!;

                // ================= FILTER =================
                final filteredItems = allLogs.where((item) {
                  final status = item['status']?.toString() ?? 'Dipinjam';
                  final nama =
                      (item['nama_peminjam'] ?? '').toString().toLowerCase();
                  final alat =
                      (item['nama_alat'] ?? '').toString().toLowerCase();

                  final matchesTab =
                      selectedTab == 0 ||
                      (selectedTab == 1 && status == 'Dipinjam') ||
                      (selectedTab == 2 && status == 'Selesai');

                  final matchesSearch =
                      nama.contains(searchQuery.toLowerCase()) ||
                      alat.contains(searchQuery.toLowerCase());

                  return matchesTab && matchesSearch;
                }).toList();

                if (filteredItems.isEmpty) {
                  return const Center(
                      child: Text('Data tidak ditemukan 🔍'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) =>
                      _riwayatCard(filteredItems[index]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ================= TAB BUTTON =================
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
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD =================
  Widget _riwayatCard(Map<String, dynamic> item) {
    final status = item['status'] ?? 'Dipinjam';
    final statusColor = status == 'Selesai' ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.history, color: Color(0xFF0C3B5A)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['nama_peminjam'] ?? '-',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold)),
                Text(item['nama_alat'] ?? '-'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style:
                  const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 4,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF8FAFB6),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index == 4) return;
        Widget page;
        switch (index) {
          case 0: page = const admin.DashboardAdminPage(); break;
          case 1: page = const PenggunaPage(); break;
          case 2: page = const AlatPage(); break;
          case 3: page = const kat.KategoriPage(); break;
          case 5: page = const LogoutPage(); break;
          default: return;
        }
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Pengguna'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Alat'),
        BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: 'Kategori'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
      ],
    );
  }
}
