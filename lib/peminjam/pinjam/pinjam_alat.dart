import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:peminjam_alat/petugas/setuju_status.dart'; 

class PinjamAlatPage extends StatefulWidget {
  const PinjamAlatPage({super.key});

  @override
  State<PinjamAlatPage> createState() => _PinjamAlatPageState();
}

class _PinjamAlatPageState extends State<PinjamAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  
  // Menggunakan StreamBuilder agar data otomatis update tanpa ditarik manual
  // Pastikan kolom 'id_peminjaman' adalah Primary Key di tabel Anda
  final Stream<List<Map<String, dynamic>>> _peminjamanStream = 
      Supabase.instance.client
          .from('peminjaman')
          .stream(primaryKey: ['id_peminjaman'])
          .order('id_peminjaman');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Daftar Pinjaman Anda", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _peminjamanStream,
        builder: (context, snapshot) {
          // Menampilkan loading saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menampilkan pesan error jika terjadi kesalahan pada stream
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Pastikan data tidak null
          final data = snapshot.data ?? [];
          
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada data peminjaman.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: data.length,
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, index) {
              final item = data[index];

              // --- PERBAIKAN NULL SAFETY DI SINI ---
              // Kita berikan nilai default (seperti "Tanpa Nama" atau "-") 
              // menggunakan operator ?? agar tidak terjadi error String null.
              final String namaAlat = item['nama_alat']?.toString() ?? "Alat Tidak Diketahui";
              final String status = item['status']?.toString() ?? "Menunggu";

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF8FAFB6),
                    child: Icon(Icons.inventory_2, color: Colors.white),
                  ),
                  title: Text(
                    namaAlat, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      "Status: $status",
                      style: TextStyle(
                        color: status.toLowerCase() == 'disetujui' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SetujuStatusPage(data: item)
                      )
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}