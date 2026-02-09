import 'package:flutter/material.dart';
import 'setuju_status.dart';
import 'tolak_status.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // --- HEADER ATAS ---
          Container(
            padding: const EdgeInsets.fromLTRB(25, 40, 25, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF8FAFB6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white54,
                      child: Text("R", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Raraazura",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Petugas",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "cari nama barang...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      icon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- RINGKASAN STATUS ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryBox("10", "Peminjam"),
                _buildSummaryBox("3", "Pengembalian\nHari ini"),
                _buildSummaryBox("4", "Menunggu\nPersetujuan"),
              ],
            ),
          ),

          // --- DAFTAR STATUS ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                const Text("Menunggu Persetujuan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                // Menambahkan context agar bisa navigasi
                _buildPersetujuanCard(context, "Rraazura", "laptop", "27 - 30 januari 2026"),
                _buildPersetujuanCard(context, "Claraa", "Sonny camera", "28 - 29 januari 2026"),
                const SizedBox(height: 20),
                const Text("Pengembalian Hari ini",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 10),
                _buildSelesaiCard("Elingga", "Mouse", "Kembali, 27 Januari 2026", true),
                _buildSelesaiCard("Rara aramita", "laptop", "Kembali, 27 Januari 2026", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String count, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          const Icon(Icons.person, size: 18),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildPersetujuanCard(BuildContext context, String name, String item, String date) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, color: Colors.black)),
            title: Text(name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text("Pinjam $date", style: const TextStyle(fontSize: 11)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item, style: const TextStyle(fontSize: 12)),
                const Text("1 unit",
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // NAVIGASI KE SETUJU
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SetujuStatusPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF8FAFB6),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(15)))),
                  child: const Text("Setuju", style: TextStyle(color: Colors.white)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // NAVIGASI KE TOLAK
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TolakStatusPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE57373),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(15)))),
                  child: const Text("Tolak", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSelesaiCard(String name, String item, String date, bool isTerlambat) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(
                backgroundColor: Colors.black12,
                child: Icon(Icons.person, color: Colors.black)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(item, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                if (isTerlambat)
                  const Text("Terlambat",
                      style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    minimumSize: const Size(80, 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Selesai", style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}