// lib/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/screens/auth/auth_wrapper.dart';

/// WelcomeScreen adalah halaman pertama yang dilihat pengguna.
/// Berisi pengenalan singkat aplikasi dan tombol untuk memulai.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Memberi gradien warna latar belakang yang menarik
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade200, Colors.purple.shade200],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ikon aplikasi atau logo
                const Icon(Icons.psychology, size: 100, color: Colors.white),
                const SizedBox(height: 24),
                // Judul aplikasi
                const Text(
                  'Selamat Datang di Fast Konseling',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Deskripsi singkat
                Text(
                  'Temukan dukungan kesehatan mental Anda di sini. Bicaralah dengan para profesional kapan saja.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 48),
                // Tombol untuk lanjut ke halaman login/utama
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // Navigasi ke AuthWrapper yang akan menentukan halaman selanjutnya
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const AuthWrapper()),
                    );
                  },
                  child: const Text('Mulai Sekarang'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}