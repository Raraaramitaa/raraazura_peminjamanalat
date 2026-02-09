import 'package:flutter/material.dart';

// Import file lainnya jika Anda ingin memisahkannya (opsional)
// import 'selesai.dart';
// import 'denda.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  // Variabel untuk melacak tab mana yang sedang aktif
  // 0: Pengembalian, 1: Selesai, 2: Denda
  int _activeTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Hallo Petugas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hallo Petugas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    size: 45,
                    color: Color(0xFF8FAFB6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab Menu - Sekarang bisa diklik
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem('Pengembalian', 0),
                _buildTabItem('Selesai', 1),
                _buildTabItem('Denda', 2),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Area Konten Dinamis berdasarkan Tab yang dipilih
          Expanded(
            child: SingleChildScrollView(
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk memanggil konten sesuai tab
  Widget _buildContent() {
    switch (_activeTabIndex) {
      case 0:
        return _contentPengembalian();
      case 1:
        return _contentSelesai(); // Ini bisa diganti 'return SelesaiPage();' jika beda file
      case 2:
        return _contentDenda(); // Ini bisa diganti 'return DendaPage();' jika beda file
      default:
        return _contentPengembalian();
    }
  }

  // Helper untuk membuat tombol Tab yang bisa diklik
  Widget _buildTabItem(String label, int index) {
    bool isActive = _activeTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeTabIndex = index;
        });
      },
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF8FAFB6) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  // --- KONTEN TAB PENGEMBALIAN ---
  Widget _contentPengembalian() {
    return _baseCard(
      statusLabel: 'Terlambat 1 Hari',
      statusColor: Colors.red,
      bottomRightWidget: const Row(
        children: [
          Icon(Icons.access_time, size: 14, color: Colors.orange),
          SizedBox(width: 5),
          Text(
            'Menunggu Persetujuan',
            style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --- KONTEN TAB SELESAI ---
  Widget _contentSelesai() {
    return _baseCard(
      statusLabel: 'Tepat Waktu',
      statusColor: Colors.green,
      bottomRightWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF8FAFB6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text('Selesai', style: TextStyle(color: Colors.white, fontSize: 10)),
      ),
    );
  }

  // --- KONTEN TAB DENDA ---
  Widget _contentDenda() {
    return _baseCard(
      statusLabel: 'Denda: Rp 50.000',
      statusColor: Colors.red,
      bottomRightWidget: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF8FAFB6),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text('Validasi Pembayaran', style: TextStyle(color: Colors.white, fontSize: 10)),
      ),
    );
  }

  // Widget Card Dasar (Reusable) agar kode tidak panjang berulang
  Widget _baseCard({
    required String statusLabel, 
    required Color statusColor, 
    required Widget bottomRightWidget
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFB4C8CC),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(backgroundColor: Colors.black, child: Icon(Icons.person, color: Colors.white)),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Aisyah Najwa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('aisyah@gmail.com', style: TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
                  ],
                ),
                Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
            const Divider(color: Colors.white, thickness: 1, height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.laptop, color: Color(0xFF8FAFB6)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ASUS Zenbook S 16 (UM5606)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Tanggal Pinjam : 12/01/2026', style: TextStyle(fontSize: 11)),
                      Text('Tanggal Kembali : 15/01/2026', style: TextStyle(fontSize: 11)),
                      Text('Tanggal Tenggat : 14/01/2026', style: TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                bottomRightWidget,
              ],
            ),
          ],
        ),
      ),
    );
  }
}