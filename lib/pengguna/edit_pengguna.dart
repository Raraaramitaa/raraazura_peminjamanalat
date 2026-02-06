import 'package:flutter/material.dart';

class EditPenggunaPage extends StatefulWidget {
  const EditPenggunaPage({super.key});

  @override
  State<EditPenggunaPage> createState() => _EditPenggunaPageState();
}

class _EditPenggunaPageState extends State<EditPenggunaPage> {
  bool _obscure = true;
  String _jenisAkun = 'Peminjam';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBFD6DB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8FAFB6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Pengguna'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFBFD6DB),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              _field(label: 'Nama', value: 'Rara Aramita'),
              _field(label: 'Email', value: 'peminjam@gmail.com'),
              _passwordField(),
              _dropdownField(),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _button(
                    text: 'Batal',
                    color: Colors.grey.shade300,
                    textColor: Colors.black,
                    onTap: () => Navigator.pop(context),
                  ),
                  _button(
                    text: 'Simpan',
                    color: const Color(0xFF8FAFB6),
                    textColor: Colors.white,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ================= FIELD =================

  Widget _field({required String label, required String value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          const Text(':'),
          const SizedBox(width: 10),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text(
            'Sandi',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          const Text(':'),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: _obscure,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'raraazura',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() => _obscure = !_obscure);
            },
          )
        ],
      ),
    );
  }

  Widget _dropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue),
          ),
          child: Row(
            children: [
              const Text(
                'Jenis akun',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              const Text(':'),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_jenisAkun),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _jenisAkun,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: 'Peminjam',
                  child: Text('Peminjam'),
                ),
                DropdownMenuItem(
                  value: 'Petugas',
                  child: Text('Petugas'),
                ),
              ],
              onChanged: (value) {
                setState(() => _jenisAkun = value!);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ================= BUTTON =================

  Widget _button({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 120,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
