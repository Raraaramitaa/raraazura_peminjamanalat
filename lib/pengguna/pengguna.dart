// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'tambah_pengguna.dart';
import 'edit_pengguna.dart';
import 'hapus_pengguna.dart';

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  // Data pengguna
  List<Map<String, String>> pengguna = [
    {'role': 'Admin', 'nama': 'Rara Aramita', 'email': 'rara@gmail.com'},
    {'role': 'Petugas', 'nama': 'Azzuraa', 'email': 'azura@gmail.com'},
    {'role': 'Admin', 'nama': 'Lingga Azzay', 'email': 'lingga@gmail.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        title: const Text('Pengguna'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pengguna.length,
        itemBuilder: (context, index) {
          final user = pengguna[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const CircleAvatar(child: Icon(Icons.person)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['role']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(user['nama']!),
                      Text(
                        user['email']!,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditPenggunaPage()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => DialogHapusPengguna(
                        onHapus: () {
                          setState(() {
                            pengguna.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () async {
          // 1. Menunggu hasil dari halaman tambah menggunakan 'await'
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPenggunaPage(),
            ),
          );

          // 2. Cek jika result tidak null (artinya tombol simpan ditekan)
          if (result != null && result is UserData) {
            setState(() {
              // Menambahkan data baru ke dalam list
              pengguna.add({
                'role': result.sebagai,
                'nama': result.nama,
                'email': result.email,
              });
            });

            // Tampilkan snackbar sukses di halaman ini
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${result.nama} berhasil ditambahkan!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}