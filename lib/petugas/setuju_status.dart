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

  // Fungsi Update Status
  Future<void> _updateStatus(String newStatus) async {
    // Mengambil ID Peminjaman dari Map data
    final idPinjam = widget.data['id_peminjaman'];

    if (idPinjam == null) {
      _showSnackBar("Gagal: id_peminjaman tidak ditemukan dalam data!", Colors.red);
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Proses Update ke Supabase menggunakan .eq('id_peminjaman', ...)
      await supabase
          .from('peminjaman')
          .update({'status': newStatus})
          .eq('id_peminjaman', idPinjam);

      if (mounted) {
        _showSnackBar("✅ Status berhasil diperbarui menjadi $newStatus", Colors.green);
        
        // Jeda sebentar agar snackbar terlihat oleh user
        await Future.delayed(const Duration(milliseconds: 600));
        
        // Kembali ke halaman sebelumnya dengan hasil 'true' agar list ter-refresh
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar("Terjadi kesalahan: $e", Colors.red);
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  // Fungsi pembantu untuk menampilkan pesan di bawah layar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Proteksi data Null pada UI
    final String status = widget.data['status']?.toString() ?? 'Menunggu';
    final bool isDisetujui = status.toLowerCase() == "disetujui";

    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      appBar: AppBar(
        title: const Text("Detail Persetujuan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: _isUpdating
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    // Icon Status Visual
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: isDisetujui ? Colors.green : Colors.orange,
                      child: Icon(
                        isDisetujui ? Icons.check : Icons.hourglass_empty,
                        size: 45,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      isDisetujui ? "Status: Disetujui" : "Status: Menunggu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDisetujui ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Barisan Informasi Data
                    _buildReadOnlyField("Nama Alat", widget.data['nama_alat']?.toString() ?? "-"),
                    _buildReadOnlyField("Peminjam", widget.data['nama_peminjam']?.toString() ?? "-"),
                    _buildReadOnlyField("Jumlah Alat", widget.data['total_alat']?.toString() ?? "0"),
                    _buildReadOnlyField("Tanggal Pinjam", widget.data['tanggal_pinjam']?.toString() ?? "-"),

                    const SizedBox(height: 40),

                    // Tombol Aksi (Hanya muncul jika belum disetujui)
                    if (!isDisetujui)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FAFB6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () => _updateStatus("Disetujui"),
                          child: const Text(
                            "SETUJUI SEKARANG",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  // Widget pembantu untuk membuat kotak info data
  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}