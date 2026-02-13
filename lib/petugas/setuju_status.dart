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
  late String _currentStatus; // Variable lokal untuk update UI instan

  @override
  void initState() {
    super.initState();
    // Inisialisasi status dari data yang dikirim
    _currentStatus = widget.data['status']?.toString().toLowerCase() ?? 'menunggu';
  }

  // ================= FUNGSI UPDATE STATUS =================
  Future<void> _updateStatus(String newStatus) async {
    if (_isUpdating) return;

    // Mengambil ID dari map
    final dynamic idPinjam = widget.data['id_peminjaman'];

    if (idPinjam == null) {
      _showSnackBar("Gagal: ID Transaksi tidak ditemukan!", Colors.red);
      return;
    }

    setState(() => _isUpdating = true);

    try {
      // Eksekusi Update ke Supabase
      await supabase
          .from('peminjaman')
          .update({'status': newStatus})
          .eq('id_peminjaman', idPinjam);

      if (mounted) {
        setState(() {
          _currentStatus = newStatus; // Update tampilan lokal
        });
        
        _showSnackBar("✅ Berhasil: Peminjaman Disetujui", Colors.green);
        
        await Future.delayed(const Duration(milliseconds: 800));
        Navigator.pop(context, true); // Kembali ke list
      }
    } catch (e) {
      _showSnackBar("Kesalahan: $e", Colors.red);
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
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek apakah status sudah disetujui
    final bool isDisetujui = _currentStatus == "disetujui" || _currentStatus == "selesai";

    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      appBar: AppBar(
        title: const Text("Persetujuan Alat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                      isDisetujui ? Icons.check_circle : Icons.pending_actions,
                      size: 80,
                      color: isDisetujui ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isDisetujui ? "STATUS: DISETUJUI" : "STATUS: MENUNGGU KONFIRMASI",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: isDisetujui ? Colors.green : Colors.orange
                      ),
                    ),
                    const SizedBox(height: 30),

                    // --- CARD INFORMASI ---
                    _infoBox("Nama Peminjam", widget.data['nama_peminjam'] ?? "-"),
                    _infoBox("Barang yang Dipinjam", widget.data['nama_alat'] ?? "-"),
                    _infoBox("Jumlah Unit", "${widget.data['total_alat'] ?? '0'} Unit"),
                    _infoBox("Periode Pinjam", widget.data['tanggal_pinjam'] ?? "-"),

                    const SizedBox(height: 40),

                    // Tombol Hanya Muncul Jika Status Masih Menunggu
                    if (!isDisetujui)
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FAFB6),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          onPressed: () => _updateStatus("disetujui"),
                          child: const Text(
                            "SETUJUI SEKARANG",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      )
                    else
                      const Text(
                        "Transaksi ini telah disetujui.",
                        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
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
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}