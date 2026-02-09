import 'package:flutter/material.dart';

class PinjamAlatPage extends StatelessWidget {
  const PinjamAlatPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hapus Scaffold dan BottomNav agar menyatu dengan Dashboard
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.only(top: 60, bottom: 30, left: 25, right: 25),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF8FAFB6),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFD9D9D9),
                child: Icon(Icons.person, color: Colors.black45, size: 35),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hallo, Selamat datang", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)),
                  Text("Rara Aramita Azura", style: TextStyle(fontSize: 14, color: Colors.white)),
                ],
              )
            ],
          ),
        ),
        
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildPinjamCard(
                "ASUS Zenbook S 16 (UM5606)",
                "14-16 Januari 2026",
                "assets/images/laptop.png",
                "Menunggu",
                Colors.red,
              ),
              const SizedBox(height: 15),
              _buildPinjamCard(
                "Canon Camera US 24.2",
                "14-16 Januari 2026",
                "assets/images/camera.png",
                "Disetujui",
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPinjamCard(String title, String date, String imgPath, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          // Gambar Alat
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.black45),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 14, color: Color(0xFF4A90E2)),
                    const SizedBox(width: 5),
                    Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text("● Tersedia", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Total: 2 alat", style: TextStyle(fontSize: 10, color: Colors.grey)),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(status, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}