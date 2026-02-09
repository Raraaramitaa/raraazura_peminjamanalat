import 'package:flutter/material.dart';

class TolakStatusPage extends StatefulWidget {
  const TolakStatusPage({super.key});

  @override
  State<TolakStatusPage> createState() => _TolakStatusPageState();
}

class _TolakStatusPageState extends State<TolakStatusPage> {
  @override
  void initState() {
    super.initState();
    // Memunculkan dialog otomatis setelah halaman dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTolakDialog();
    });
  }

  void _showTolakDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 15),
            const Text(
              "Tolak?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 5),
            const Text(
              "Alat sudah tersewa",
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: Colors.grey.shade100,
                    ),
                    child: const Text("Batal", style: TextStyle(color: Colors.black54)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Tutup Dialog
                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text("Ya, Tolak", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8FAFB6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Persetujuan",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background content
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil Peminjam
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.person, size: 40, color: Colors.black54),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rara Aramita Azura",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "raraazura@gmail.com",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Container Daftar Barang
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildItemRow("Sonny Camera", "1 unit", "https://via.placeholder.com/50"),
                        const Divider(height: 1),
                        _buildItemRow("Laptop", "1 unit", "https://via.placeholder.com/50"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Fields
                  _buildLabel("Nama"),
                  _buildTextField("Raraazura"),
                  
                  _buildLabel("Jumlah"),
                  _buildTextField("2"),

                  const SizedBox(height: 15),
                  
                  // Baris Tanggal & Waktu (Ambil)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Ambil"),
                            _buildIconField("12/01/2026", Icons.calendar_today_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            _buildIconField("10:00", Icons.access_time),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Baris Tanggal & Waktu (Kembali)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Kembali"),
                            _buildIconField("15/01/2026", Icons.calendar_today_outlined),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            _buildIconField("14:00", Icons.access_time),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Baris Tanggal & Waktu (Tenggat)
                  _buildLabel("Tenggat Pengembalian"),
                  Row(
                    children: [
                      Expanded(child: _buildIconField("14/01/2026", Icons.calendar_today_outlined)),
                      const SizedBox(width: 15),
                      Expanded(child: _buildIconField("14:00", Icons.access_time)),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Tombol di bawah
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            side: const BorderSide(color: Color(0xFF8FAFB6)),
                          ),
                          child: const Text("Tidak Setuju", style: TextStyle(color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FAFB6),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            elevation: 0,
                          ),
                          child: const Text("Setuju", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Overlay gelap saat dialog muncul
          Container(color: Colors.black.withOpacity(0.4)),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildItemRow(String title, String qty, String imgUrl) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(qty, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField(String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget _buildIconField(String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(color: Colors.black87, fontSize: 13)),
        ],
      ),
    );
  }
}