// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Ganti import di bawah ini sesuai path project Anda
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
  int selectedTab = 0; // 0: Semua, 1: Dipinjam, 2: Selesai
  String searchQuery = '';

  // --- FUNGSI HAPUS RIWAYAT DENGAN KONFIRMASI ---
  Future<void> _konfirmasiHapus(int id, String nama) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Riwayat?'),
        content: Text('Apakah Anda yakin ingin menghapus riwayat milik "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _hapusRiwayat(id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _hapusRiwayat(int id) async {
    try {
      // Proses Delete ke Supabase
      await supabase.from('log_aktivitas').delete().eq('id', id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Riwayat berhasil dihapus'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
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
          'Riwayat Log Aktivitas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Baris Pencarian
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari Peminjam...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Baris Filter Tab
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabItem("Semua", 0),
                _buildTabItem("Dipinjam", 1),
                _buildTabItem("Selesai", 2),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Area List Data (StreamBuilder)
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              // Mengambil data real-time
              stream: supabase
                  .from('log_aktivitas')
                  .stream(primaryKey: ['id'])
                  .order('created_at', ascending: false),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi Kesalahan: ${snapshot.error}'));
                }

                final rawData = snapshot.data ?? [];

                if (rawData.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 50, color: Colors.grey),
                        Text('Tidak ada riwayat ditemukan'),
                      ],
                    ),
                  );
                }

                // Filter data
                final filteredLogs = rawData.where((item) {
                  final status = item['status']?.toString() ?? 'Dipinjam';
                  final nama = item['nama_peminjam']?.toString().toLowerCase() ?? '';
                  
                  final matchesTab = selectedTab == 0 || 
                                    (selectedTab == 1 && status == 'Dipinjam') || 
                                    (selectedTab == 2 && status == 'Selesai');
                  
                  final matchesSearch = nama.contains(searchQuery.toLowerCase());
                  
                  return matchesTab && matchesSearch;
                }).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(child: Text('Data tidak ditemukan 🔍'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final item = filteredLogs[index];
                    return _buildRiwayatCard(item);
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0C3B5A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF0C3B5A), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF0C3B5A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRiwayatCard(Map<String, dynamic> item) {
    final status = item['status'] ?? 'Dipinjam';
    final color = status == 'Selesai' ? Colors.green : Colors.orange;
    final String namaPeminjam = item['nama_peminjam'] ?? '-';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF0C3B5A),
          child: Icon(Icons.history, color: Colors.white),
        ),
        title: Text(
          namaPeminjam,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Alat: ${item['nama_alat'] ?? '-'}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _konfirmasiHapus(item['id'], namaPeminjam),
            ),
          ],
        ),
      ),
    );
  }

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
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