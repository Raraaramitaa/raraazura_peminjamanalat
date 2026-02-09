import 'package:flutter/material.dart';

class DetailAlatPage extends StatefulWidget {
  final Map<String, dynamic> alat;

  const DetailAlatPage({super.key, required this.alat});

  @override
  State<DetailAlatPage> createState() => _DetailAlatPageState();
}

class _DetailAlatPageState extends State<DetailAlatPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFB4C8CC), // Warna background sesuai gambar
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 30),
              // Gambar Produk
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: widget.alat['foto_url'] != null
                    ? Image.network(
                        widget.alat['foto_url'],
                        height: 180,
                        fit: BoxFit.contain,
                      )
                    : const Icon(Icons.laptop_mac, size: 150),
              ),
              const SizedBox(height: 20),
              // Nama dan Spesifikasi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.alat['nama_alat'] ?? 'SAMSUNG Galaxy Book 4',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // List Spesifikasi
                    _buildSpecItem('Layar anti-silau LED full-HD 15,6 inci'),
                    _buildSpecItem('Intel Core 7 CPU 150U'),
                    _buildSpecItem('RAM LPDDR4x-16GB'),
                    _buildSpecItem('Windows 11'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Input Quantity (Plus Minus)
              Container(
                width: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQtyBtn(Icons.remove, () {
                      if (quantity > 1) setState(() => quantity--);
                    }),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildQtyBtn(Icons.add, () {
                      setState(() => quantity++);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Info Stok
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black87),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Stok Tersedia: 1',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              // Tombol Keranjang
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    // Logika tambah ke keranjang
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB4C8CC),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    side: const BorderSide(color: Colors.black87),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Keranjang',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
            right: icon == Icons.remove ? const BorderSide(color: Colors.grey) : BorderSide.none,
            left: icon == Icons.add ? const BorderSide(color: Colors.grey) : BorderSide.none,
          ),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}