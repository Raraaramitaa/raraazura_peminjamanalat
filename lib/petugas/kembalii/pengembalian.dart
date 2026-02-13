import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  int _activeTabIndex = 0;
  final supabase = Supabase.instance.client;

  Future<void> _konfirmasiPengembalian(dynamic id) async {
    try {
      await supabase
          .from('peminjaman')
          .update({'status': 'selesai'})
          .eq('id_peminjaman', id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil Konfirmasi"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildTabMenu(),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF8FAFB6),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Hallo Petugas', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Icon(Icons.account_circle, size: 45, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildTabMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTabItem('Pengembalian', 0),
          _buildTabItem('Selesai', 1),
          _buildTabItem('Denda', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTabIndex = index),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8FAFB6) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ),
    );
  }

  Widget _buildContent() {
    String filterStatus = 'menunggu_kembali';
    if (_activeTabIndex == 1) filterStatus = 'selesai';
    if (_activeTabIndex == 2) filterStatus = 'denda';

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: supabase.from('peminjaman').stream(primaryKey: ['id_peminjaman']).eq('status', filterStatus),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;
        if (data.isEmpty) return const Center(child: Text("Tidak ada data."));

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return _baseCard(
              id: item['id_peminjaman'],
              nama: item['nama_peminjam'] ?? "User",
              email: item['email'] ?? "-",
              alat: item['nama_alat'] ?? "-",
              tglPinjam: item['tanggal_pinjam'] ?? "-",
              tglKembali: item['tanggal_kembali'] ?? "-",
              statusLabel: _activeTabIndex == 0 ? 'Menunggu Konfirmasi' : (_activeTabIndex == 1 ? 'Selesai' : 'Denda Aktif'),
              statusColor: _activeTabIndex == 1 ? Colors.green : Colors.red,
            );
          },
        );
      },
    );
  }

  Widget _baseCard({
    required dynamic id,
    required String nama, 
    required String email, 
    required String alat,
    required String tglPinjam,
    required String tglKembali,
    required String statusLabel, 
    required Color statusColor, 
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFB4C8CC), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(email, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const Divider(color: Colors.white),
          Text(alat, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Pinjam: $tglPinjam | Kembali: $tglKembali', style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(5)),
                child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              if (_activeTabIndex == 0)
                ElevatedButton(
                  onPressed: () => _konfirmasiPengembalian(id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB6),
                    foregroundColor: Colors.white,
                    // PERBAIKAN: Gunakan minimumSize, bukan height
                    minimumSize: const Size(80, 35),
                  ),
                  child: const Text("Konfirmasi", style: TextStyle(fontSize: 10)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}