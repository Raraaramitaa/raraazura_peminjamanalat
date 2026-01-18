import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan URL dan AnonKey ini sudah benar dari Project Settings Supabase Anda
  await Supabase.initialize(
    url: 'https://uzpsmxqxwkyhzlraarej.supabase.co',
    anonKey: 'sb_publishable_IUPR8oafSKHE7d2dcumHcA_JCJtPjp9',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Database Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Peminjaman Alat - Log'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isLoading = false;

  final supabase = Supabase.instance.client;

  Future<void> _incrementAndSave() async {
    setState(() {
      _isLoading = true;
      _counter++;
    });

    try {
      // PERBAIKAN PENTING: 
      // Tabel 'log_aktivitas' di gambar Anda membutuhkan 'id_user' (UUID).
      // Jika belum ada sistem Login, Anda harus menggunakan UUID dummy yang valid
      // atau mematikan constraint NOT NULL di dashboard Supabase untuk kolom id_user.
      
      await supabase.from('log_aktivitas').insert({
        'aktivitas': 'User menekan tombol tambah. Total klik: $_counter',
        'waktu': DateTime.now().toIso8601String(),
        // Contoh UUID dummy (ganti dengan ID user asli jika sudah ada sistem auth)
        // 'id_user': '00000000-0000-0000-0000-000000000000', 
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil mencatat aktivitas ke database!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Menampilkan pesan error yang lebih spesifik
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'), 
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      // Kembalikan counter jika gagal simpan (opsional)
      setState(() => _counter--);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Tekan tombol untuk mencatat aktivitas:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            if (_isLoading) 
              const CircularProgressIndicator()
            else
              const Text("Database Siap", style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : _incrementAndSave,
        tooltip: 'Simpan ke Database',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}