import 'package:flutter/material.dart';
import 'package:peminjam_alat/peminjam/keranjang.dart'; 

class DetailAlatPage extends StatefulWidget {
  final Map<String, dynamic> alat;

  const DetailAlatPage({super.key, required this.alat});

  @override
  State<DetailAlatPage> createState() => _DetailAlatPageState();
}

class _DetailAlatPageState extends State<DetailAlatPage> {
  // Inisialisasi jumlah awal
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari map alat yang dikirim
    final String name = widget.alat['nama_alat'] ?? 'Nama Alat';
    final String? fotoUrl = widget.alat['foto_url'];
    // Pastikan stok adalah angka, jika null beri default 1
    final int stok = widget.alat['stok'] ?? 1; 
    final String deskripsi = widget.alat['deskripsi'] ?? 
        'Spesifikasi tidak tersedia untuk alat ini.';
    final String kategori = widget.alat['kategori'] ?? 'Umum';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Alat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(25.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFB4C8CC),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (fotoUrl != null && fotoUrl.isNotEmpty)
                    ? Image.network(
                        fotoUrl,
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 100),
                      )
                    : const Icon(Icons.inventory_2, size: 150, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              // Nama dan Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Deskripsi / Spesifikasi:",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      deskripsi,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- BAGIAN TOMBOL TAMBAH KURANG (QUANTITY) ---
              Container(
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Kurangi (-)
                    _buildQtyBtn(Icons.remove, () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    }),
                    
                    // Angka Quantity
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Tombol Tambah (+)
                    _buildQtyBtn(Icons.add, () {
                      if (quantity < stok) {
                        setState(() {
                          quantity++;
                        });
                      } else {
                        // Opsional: Tampilkan pesan jika melebihi stok
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Jumlah melebihi stok tersedia!")),
                        );
                      }
                    }),
                  ],
                ),
              ),
              // ----------------------------------------------

              const SizedBox(height: 15),
              // Info Stok Dinamis
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black87),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Stok Tersedia: $stok',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              // Tombol Keranjang
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KeranjangPage(
                          itemBaru: {
                            'nama': name,
                            'kategori': kategori,
                            'status': widget.alat['status'] ?? 'Tersedia',
                            'jumlah': quantity,
                            'foto': fotoUrl,
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: const BorderSide(color: Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk tombol plus dan minus agar kode lebih rapi
  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }
}