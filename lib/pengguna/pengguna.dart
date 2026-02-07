import 'package:flutter/material.dart';
import 'tambah_pengguna.dart';
import 'edit_pengguna.dart';
import 'hapus_pengguna.dart';

class PenggunaPage extends StatelessWidget {
  const PenggunaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        title: const Text('Pengguna'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _userCard(
            context,
            role: 'Admin',
            nama: 'Rara Aramita',
            email: 'rara@gmail.com',
          ),
          _userCard(
            context,
            role: 'Petugas',
            nama: 'Azzuraa',
            email: 'azura@gmail.com',
          ),
          _userCard(
            context,
            role: 'Admin',
            nama: 'Lingga Azzay',
            email: 'lingga@gmail.com',
          ),
        ],
      ),
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

  Widget _userCard(
    BuildContext context, {
    required String role,
    required String nama,
    required String email,
  }) {
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
                Text(role,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(nama),
                Text(email, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
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
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const PenggunaPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}
