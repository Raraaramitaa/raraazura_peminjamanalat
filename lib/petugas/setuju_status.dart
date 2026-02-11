// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetujuStatusPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const SetujuStatusPage({super.key, required this.data});

  @override
  State<SetujuStatusPage> createState() => _SetujuStatusPageState();
}

class _SetujuStatusPageState extends State<SetujuStatusPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Debugging: Melihat apa saja kunci yang masuk ke halaman ini
    debugPrint("Isi Data Masuk: ${widget.data}");
  }

  // ================= FUNGSI UPDATE STATUS =================
  Future<void> _updateStatus(String newStatus) async {
    if (_isUpdating) return;

    // --- LOGIKA ANTI-ERROR: MENCARI ID SECARA OTOMATIS ---
    // Mencoba mencari ID dari semua kemungkinan nama kolom yang ada di database Anda
    final dynamic idPinjam = widget.data['id_peminjaman'] ?? 
                             widget.data['id'] ?? 
                             widget.data['id_pinjam'] ??
                             widget.data['id_user'] ??
                             widget.data['id_alat']; // Mencari kemungkinan key lain

    if (idPinjam == null) {
      _showSnackBar("Gagal: ID tidak ditemukan. Cek Console Log!", Colors.red);
      debugPrint("ERROR: Tidak ada key ID dalam data: ${widget.data.keys.toList()}");
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Eksekusi Update ke Supabase
      // Pastikan nama kolom Primary Key di tabel 'peminjaman' Anda adalah 'id_peminjaman'
      await supabase
          .from('peminjaman')
          .update({'status': newStatus})
          .eq('id_peminjaman', idPinjam);

      if (mounted) {
        _showSnackBar("✅ Berhasil: Status diperbarui", Colors.green);
        
        await Future.delayed(const Duration(milliseconds: 700));

        // Kembali dengan 'true' agar halaman list memanggil fetch ulang
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Jika error database tetap muncul, ini akan menangkap detailnya
      _showSnackBar("Kesalahan DB: $e", Colors.red);
      debugPrint("Detail Error Supabase: $e");
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil status dan ubah ke lowercase untuk pengecekan
    final String status = widget.data['status']?.toString().toLowerCase() ?? 'menunggu';
    final bool isDisetujui = status == "disetujui" || status == "selesai";

    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      appBar: AppBar(
        title: const Text("Persetujuan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: _isUpdating
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(
                      isDisetujui ? Icons.check_circle : Icons.pending,
                      size: 70,
                      color: isDisetujui ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isDisetujui ? "STATUS: DISETUJUI" : "STATUS: MENUNGGU",
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: isDisetujui ? Colors.green : Colors.orange
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- CARD INFORMASI ---
                    _infoBox("Peminjam", widget.data['nama_peminjam'] ?? widget.data['email'] ?? "-"),
                    _infoBox("Nama Alat", widget.data['nama_alat'] ?? "-"),
                    _infoBox("Jumlah", "${widget.data['total_alat'] ?? widget.data['jumlah_pinjam'] ?? '0'} Unit"),
                    _infoBox("Tanggal", widget.data['tanggal_pinjam'] ?? "-"),

                    const SizedBox(height: 40),

                    // Tombol muncul hanya jika status belum disetujui
                    if (!isDisetujui)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FAFB6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () => _updateStatus("disetujui"),
                          child: const Text(
                            "SETUJUI SEKARANG",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}