// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tambah_pengguna.dart';
import 'edit_pengguna.dart';
import 'hapus_pengguna.dart';

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> penggunaList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPengguna();
  }

  // Mengambil data pengguna dari tabel profiles
  Future<void> fetchPengguna() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    
    try {
      final data = await supabase
          .from('profiles')
          .select('id, email, role') 
          .order('role', ascending: true);

      if (mounted) {
        setState(() {
          penggunaList = List<Map<String, dynamic>>.from(data);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetch data: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fungsi menghapus pengguna
  Future<void> hapusPengguna(String id, String email) async {
    try {
      await supabase.from('profiles').delete().eq('id', id);
      fetchPengguna(); // Refresh data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Akun $email berhasil dihapus'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        title: const Text('Daftar Pengguna', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            onPressed: fetchPengguna,
            icon: const Icon(Icons.refresh, color: Colors.white),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF8FAFB6)))
          : penggunaList.isEmpty
              ? const Center(child: Text('Tidak ada pengguna ditemukan.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: penggunaList.length,
                  itemBuilder: (context, index) {
                    final user = penggunaList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user['role'] == 'admin' 
                              ? Colors.red[300] 
                              : const Color(0xFF8FAFB6),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          user['email']?.toString() ?? 'Tidak ada email',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Role: ${user['role']?.toString().toUpperCase()}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                              onPressed: () async {
                                // Tunggu hasil (true) dari halaman edit untuk refresh data
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPenggunaPage(userData: user),
                                  ),
                                );
                                if (result == true) fetchPengguna();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => DialogHapusPengguna(
                                    onHapus: () => hapusPengguna(
                                      user['id'].toString(),
                                      user['email'].toString(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPenggunaPage()),
          );
          if (result == true) fetchPengguna();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}