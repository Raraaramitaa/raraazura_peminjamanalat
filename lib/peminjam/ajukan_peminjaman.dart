// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:peminjam_alat/peminjam/pinjam/pinjam_alat.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ignore: unused_import
import 'pinjam_alat.dart'; 

class AjukanPeminjamanPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const AjukanPeminjamanPage({super.key, required this.items});

  @override
  State<AjukanPeminjamanPage> createState() => _AjukanPeminjamanPageState();
}

class _AjukanPeminjamanPageState extends State<AjukanPeminjamanPage> {
  final SupabaseClient supabase = Supabase.instance.client;

  // Input tetap menggunakan format teks agar aman dari error tipe data
  final TextEditingController _tglAmbil = TextEditingController(text: "12/02/2026");
  final TextEditingController _jamAmbil = TextEditingController(text: "10:00");
  final TextEditingController _tglKembali = TextEditingController(text: "15/02/2026");
  final TextEditingController _jamKembali = TextEditingController(text: "14:00");

  Future<void> _kirimPengajuan() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = supabase.auth.currentUser;
      final String userEmail = user?.email ?? "Peminjam Umum";

      for (var item in widget.items) {
        // STEP 1: Masuk ke tabel Peminjaman
        await supabase.from('peminjaman').insert({
          'nama_alat': item['nama'].toString(),
          'nama_peminjam': userEmail,
          'jumlah': item['jumlah'].toString(),
          'tgl_ambil': _tglAmbil.text,
          'jam_ambil': _jamAmbil.text,
          'tgl_kembali': _tglKembali.text,
          'jam_kembali': _jamKembali.text,
          'status': 'Menunggu',
        });

        // STEP 2: OTOMATIS Masuk ke Riwayat (log_aktivitas)
        await supabase.from('log_aktivitas').insert({
          'nama_peminjam': userEmail,
          'nama_alat': item['nama'].toString(),
          'status': 'Dipinjam', 
        });
      }

      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil dikirim ke Dashboard Admin!"), backgroundColor: Colors.green),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PinjamAlatPage()),
        (route) => false,
      );
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gagal"),
        content: Text(msg),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Konfirmasi"), backgroundColor: const Color(0xFF8FAFB6)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, i) => Card(
                  child: ListTile(title: Text(widget.items[i]['nama']), subtitle: Text("Jumlah: ${widget.items[i]['jumlah']}")),
                ),
              ),
            ),
            TextField(controller: _tglAmbil, decoration: const InputDecoration(labelText: "Tgl Ambil")),
            TextField(controller: _tglKembali, decoration: const InputDecoration(labelText: "Tgl Kembali")),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8FAFB6), minimumSize: const Size(double.infinity, 50)),
              onPressed: _kirimPengajuan, 
              child: const Text("KIRIM PENGAUJAN", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}