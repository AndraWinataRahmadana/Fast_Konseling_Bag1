import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang, Pengguna!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Psikolog Populer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Di sini Anda dapat menambahkan daftar psikolog populer (misalnya, dalam ListView)
          ],
        ),
      ),
    );
  }
}