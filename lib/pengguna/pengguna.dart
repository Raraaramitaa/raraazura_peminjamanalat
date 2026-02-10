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

  // List data pengguna
  List<Map<String, dynamic>> penggunaList = [];

  // Status loading
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPengguna();
  }

  // ================= AMBIL DATA PENGGUNA =================
  Future<void> fetchPengguna() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      // 🔥 PERBAIKAN DI SINI:
      // Ambil SEMUA role: admin, petugas, peminjam
      final data = await supabase
          .from('profiles')
          .select('id, email, role')
          .inFilter('role', ['admin', 'petugas', 'peminjam'])
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
      }
    }
  }

  // ================= HAPUS PENGGUNA =================
  Future<void> hapusPengguna(String id, String email) async {
    try {
      await supabase.from('profiles').delete().eq('id', id);

      // Refresh data setelah hapus
      fetchPengguna();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Akun $email berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        title: const Text(
          'Daftar Pengguna',
          style: TextStyle(color: Colors.white),
        ),
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

      // ================= BODY =================
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF8FAFB6),
              ),
            )
          : penggunaList.isEmpty
              ? const Center(
                  child: Text('Tidak ada pengguna ditemukan.'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: penggunaList.length,
                  itemBuilder: (context, index) {
                    final user = penggunaList[index];
                    final role = user['role']?.toString() ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        // ================= AVATAR =================
                        leading: CircleAvatar(
                          backgroundColor: role == 'admin'
                              ? Colors.red[300]
                              : role == 'petugas'
                                  ? Colors.orange[300]
                                  : const Color(0xFF8FAFB6),
                          child:
                              const Icon(Icons.person, color: Colors.white),
                        ),

                        // ================= EMAIL =================
                        title: Text(
                          user['email']?.toString() ??
                              'Tidak ada email',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        // ================= ROLE =================
                        subtitle: Text(
                          "Role: ${role.toUpperCase()}",
                        ),

                        // ================= AKSI =================
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tombol edit
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Colors.blue),
                              onPressed: () async {
                                final result =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPenggunaPage(
                                      userData: user,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  fetchPengguna();
                                }
                              },
                            ),

                            // Tombol hapus
                            IconButton(
                              icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) =>
                                      DialogHapusPengguna(
                                    onHapus: () =>
                                        hapusPengguna(
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

      // ================= FLOATING BUTTON =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPenggunaPage(),
            ),
          );

          // Jika berhasil menambah user → refresh
          if (result == true) {
            fetchPengguna();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
