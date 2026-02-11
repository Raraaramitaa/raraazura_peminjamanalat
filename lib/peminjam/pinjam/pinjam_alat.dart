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
  final Stream<List<Map<String, dynamic>>> _peminjamanStream = 
      Supabase.instance.client.from('peminjaman').stream(primaryKey: ['id_peminjaman']).order('id_peminjaman');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pinjaman Anda"),
        backgroundColor: const Color(0xFF8FAFB6),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _peminjamanStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          
          if (data.isEmpty) return const Center(child: Text("Kosong."));

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  title: Text(item['nama_alat'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Status: ${item['status']}"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SetujuStatusPage(data: item)));
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