import 'package:flutter/material.dart';
import 'package:peminjam_alat/auth/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
