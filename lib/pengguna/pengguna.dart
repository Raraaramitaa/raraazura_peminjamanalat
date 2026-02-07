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
                // Tombol edit
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditPenggunaPage(),
                      ),
                    );
                  },
                ),
                // Tombol hapus
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
      // Tombol tambah pengguna
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8FAFB6),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TambahPenggunaPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
