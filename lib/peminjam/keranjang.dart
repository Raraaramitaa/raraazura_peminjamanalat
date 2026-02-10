// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'ajukan_peminjaman.dart'; // Pastikan import ini ada

class KeranjangPage extends StatefulWidget {
  final Map<String, dynamic>? itemBaru;

  const KeranjangPage({super.key, this.itemBaru});

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  // Menggunakan 'static' agar daftar barang tetap tersimpan saat navigasi
  static final List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _tambahItemKeKeranjang();
  }

  void _tambahItemKeKeranjang() {
    if (widget.itemBaru != null) {
      // Cek apakah barang yang sama sudah ada berdasarkan nama
      int indexExist = _cartItems.indexWhere(
        (item) => item['nama'] == widget.itemBaru!['nama']
      );

      if (indexExist != -1) {
        _cartItems[indexExist]['jumlah'] += widget.itemBaru!['jumlah'];
      } else {
        _cartItems.add(widget.itemBaru!);
      }
    }
  }

  void _tambahJumlah(int index) {
    setState(() {
      _cartItems[index]['jumlah']++;
    });
  }

  void _kurangJumlah(int index) {
    setState(() {
      if (_cartItems[index]['jumlah'] > 1) {
        _cartItems[index]['jumlah']--;
      } else {
        // Hapus item jika jumlah mencapai 0
        _cartItems.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBCCDCF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Keranjang Alat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian Daftar Barang
          Expanded(
            child: _cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.black26),
                        SizedBox(height: 10),
                        Text("Keranjang Anda kosong", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(index);
                    },
                  ),
          ),

          // Bottom Navigation Panel (Total & Button)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: ${_cartItems.length} alat',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _cartItems.isEmpty 
                    ? null 
                    : () {
                        // NAVIGASI KE HALAMAN AJUKAN PEMINJAMAN
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AjukanPeminjamanPage(items: _cartItems),
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8FAFB6),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Ajukan Peminjaman',
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
        ],
      ),
    );
  }

  Widget _buildCartItem(int index) {
    final item = _cartItems[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (item['foto'] != null && item['foto'].isNotEmpty)
                  ? Image.network(item['foto'], fit: BoxFit.contain)
                  : const Icon(Icons.laptop_mac, size: 40, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['nama'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['kategori'],
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F5E8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        item['status'] ?? "Tersedia",
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEF0),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                _buildQtyAction(Icons.remove, () => _kurangJumlah(index)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${item['jumlah']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                _buildQtyAction(Icons.add, () => _tambahJumlah(index)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16, color: Colors.black54),
      ),
    );
  }
}