import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SetujuStatusPage(),
  ));
}

class SetujuStatusPage extends StatefulWidget {
  const SetujuStatusPage({super.key});

  @override
  State<SetujuStatusPage> createState() => _SetujuStatusPageState();
}

class _SetujuStatusPageState extends State<SetujuStatusPage> {
  // Variabel untuk melacak apakah tombol sudah diklik
  bool isActionDone = false;
  String statusMessage = "Pengajuan Disetujui!";
  Color statusColor = const Color(0xFF66BB6A);

  void _handleAction(bool setuju) {
    setState(() {
      isActionDone = true;
      if (!setuju) {
        statusMessage = "Pengajuan Ditolak";
        statusColor = Colors.redAccent;
      }
    });
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
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            children: [
              // Ikon Status (Berubah warna/ikon jika ditolak)
              CircleAvatar(
                radius: 40,
                backgroundColor: isActionDone ? statusColor : const Color(0xFF66BB6A),
                child: Icon(
                  isActionDone && statusMessage == "Pengajuan Ditolak" 
                      ? Icons.close 
                      : Icons.check, 
                  size: 50, 
                  color: Colors.white
                ),
              ),
              const SizedBox(height: 12),
              Text(
                statusMessage,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(height: 25),

              // Daftar Barang
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildItemRow(
                      "Sonny Camera",
                      "1 unit",
                      "https://cdn-icons-png.flaticon.com/512/685/685655.png",
                    ),
                    Divider(height: 1, color: Colors.grey.shade300),
                    _buildItemRow(
                      "Laptop",
                      "1 unit",
                      "https://cdn-icons-png.flaticon.com/512/428/428001.png",
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),

              _buildFieldLabel("Nama"),
              _buildReadOnlyField("Raraazura"),

              _buildFieldLabel("Jumlah"),
              _buildReadOnlyField("2"),

              const SizedBox(height: 15),
              
              // Baris Ambil
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Ambil"),
                        _buildReadOnlyField("12/01/2026", icon: Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildReadOnlyField("10:00", icon: Icons.access_time),
                  ),
                ],
              ),

              // Baris Kembali
              _buildFieldLabel("Kembali"),
              Row(
                children: [
                  Expanded(child: _buildReadOnlyField("15/01/2026", icon: Icons.calendar_today_outlined)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildReadOnlyField("14:00", icon: Icons.access_time)),
                ],
              ),

              // Baris Tenggat
              _buildFieldLabel("Tenggat Pengembalian"),
              Row(
                children: [
                  Expanded(child: _buildReadOnlyField("14/01/2026", icon: Icons.calendar_today_outlined)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildReadOnlyField("14:00", icon: Icons.access_time)),
                ],
              ),

              // Jarak sebelum tombol
              const SizedBox(height: 40),

              // LOGIKA TOMBOL: Jika isActionDone false, tampilkan tombol. Jika true, tampilkan SizedBox kosong (hilang).
              if (!isActionDone) 
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _handleAction(false),
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
                        onPressed: () => _handleAction(true),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFF8FAFB6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 0,
                        ),
                        child: const Text("Setuju", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              else 
                const SizedBox.shrink(), // Bagian ini akan benar-benar kosong/hilang dari UI
                
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Helpers ---

  Widget _buildItemRow(String name, String qty, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(qty, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 8),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.black54),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}