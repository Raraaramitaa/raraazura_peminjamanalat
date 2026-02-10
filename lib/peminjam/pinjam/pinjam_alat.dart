import 'package:flutter/material.dart';
import 'package:peminjam_alat/petugas/setuju_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import 'setuju_status.dart'; // Pastikan nama file ini sesuai dengan file kedua Anda

class PinjamAlatPage extends StatefulWidget {
  const PinjamAlatPage({super.key});

  @override
  State<PinjamAlatPage> createState() => _PinjamAlatPageState();
}

class _PinjamAlatPageState extends State<PinjamAlatPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _fetchData;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Fungsi untuk memicu pengambilan data ulang
  void _refreshData() {
    setState(() {
      _fetchData = _initPeminjamanData();
    });
  }

  // Fungsi inti untuk mengambil data dari Supabase
  Future<List<Map<String, dynamic>>> _initPeminjamanData() async {
    try {
      // Menggunakan select('*') memastikan id_peminjaman ikut terambil
      final response = await supabase
          .from('peminjaman')
          .select('*')
          .order('id_peminjaman', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception("Gagal memuat data dari database");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Daftar Peminjaman", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi Kesalahan: ${snapshot.error}"));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text("Tidak ada data peminjaman saat ini."));
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshData(),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                final status = item['status'] ?? 'Menunggu';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      item['nama_alat'] ?? 'Alat Tidak Diketahui',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text("Peminjam: ${item['nama_peminjam'] ?? '-'}"),
                        const SizedBox(height: 5),
                        Text(
                          status,
                          style: TextStyle(
                            color: status == "Disetujui" ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () async {
                      // Mengirim 'item' yang berisi id_peminjaman ke halaman detail
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SetujuStatusPage(data: item),
                        ),
                      );

                      // Jika kembali membawa nilai 'true', maka refresh list
                      if (result == true) {
                        _refreshData();
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}