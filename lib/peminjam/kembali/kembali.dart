import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'denda_kembali.dart'; // PENTING: Import file denda

class KembaliPage extends StatefulWidget {
  final Map<String, dynamic>? dataPeminjaman;

  const KembaliPage({
    super.key,
    required this.dataPeminjaman,
  });

  @override
  State<KembaliPage> createState() => _KembaliPageState();
}

class _KembaliPageState extends State<KembaliPage> {
  bool _isLoading = false;
  final supabase = Supabase.instance.client;

  final Color primaryColor = const Color(0xFF8FAFB6);
  final Color bgColor = const Color(0xFFBFD6DB);

  void _prosesPengembalian() {
    setState(() => _isLoading = true);
    
    // Simulasi proses delay 1 detik sebelum pindah halaman
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isLoading = false);
        
        // NAVIGASI KE HALAMAN DENDA
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DendaRiwayatPage(),
          ),
        );
      }
    });
  }

  // ignore: unused_element
  void _showMessage(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.dataPeminjaman ?? {};
    final String tglPinjam = data['tanggal_pinjam']?.toString() ?? '14 Januari 2026';
    final String tglRencana = data['tanggal_kembali']?.toString() ?? '16 Januari 2026';
    final String tglTenggat = data['tanggal_tenggat']?.toString() ?? '15 Januari 2026';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline, color: Colors.black),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hallo, Selamat datang",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                      ),
                      Text("Rara Aramita Azura", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            
            // Konten
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDaftarAlatCard(),
                    const SizedBox(height: 20),
                    _buildInfoPeminjaman(tglPinjam, tglRencana, tglTenggat),
                    const SizedBox(height: 40),
                    _buildButtonKembalikan(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaftarAlatCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daftar Alat:", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _itemAlat("ASUS Zenbook S 16 (UM5606)", "Tersedia"),
          const Divider(),
          _itemAlat("SAMSUNG Galaxy Book4", "Tersedia"),
          const Divider(),
          const Text("Total: 2 alat", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _itemAlat(String nama, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 60, height: 40,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
            child: const Icon(Icons.laptop, size: 30, color: Colors.grey),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(nama, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                const Icon(Icons.check_circle, size: 10, color: Colors.green),
                const SizedBox(width: 4),
                Text(status, style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoPeminjaman(String pinjam, String rencana, String tenggat) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Informasi Peminjaman", style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _infoRow("Tanggal Pinjam", pinjam),
          _infoRow("Rencana Kembali", rencana),
          _infoRow("Tanggal Tenggat", tenggat),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFFFEBEE), borderRadius: BorderRadius.circular(5)),
              child: const Text("Terlambat 2 hr", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildButtonKembalikan() {
    return SizedBox(
      width: 200, height: 45,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _prosesPengembalian,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Colors.black38)),
        ),
        child: _isLoading 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text("Kembalikan", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}