// lib/screens/psychologists/psychologist_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/screens/scheduling/scheduling_screen.dart';

/// Halaman ini menampilkan detail informasi dari seorang psikolog
/// yang dipilih dari daftar.
class PsychologistDetailScreen extends StatelessWidget {
  // Menerima data psikolog yang akan ditampilkan
  final Psychologist psychologist;

  const PsychologistDetailScreen({super.key, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar dengan judul nama psikolog
      appBar: AppBar(
        title: Text(psychologist.name),
        actions: [
          // Tombol untuk berbagi profil psikolog (placeholder)
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implementasi fungsionalitas berbagi
              // Anda bisa menggunakan package 'share_plus' di sini.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur berbagi akan datang!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Menengahkan konten di layar
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Psikolog
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: psychologist.photoUrl.isNotEmpty
                  ? NetworkImage(psychologist.photoUrl)
                  : null,
              // Perbaikan: 'child' diletakkan di akhir
              child: psychologist.photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 20),
            // Nama Lengkap
            Text(
              psychologist.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Spesialisasi
            Text(
              psychologist.specialization,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Menengahkan rating
              children: [
                Icon(Icons.star, color: Colors.amber.shade600),
                const SizedBox(width: 5),
                Text(
                  psychologist.rating.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Tombol Aksi "Jadwalkan Sesi"
            SizedBox(
              width: double.infinity, // Membuat tombol selebar layar
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Navigasi ke halaman penjadwalan,
                  // mengirim data 'psychologist' lengkap
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SchedulingScreen(
                        psychologist: psychologist,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Jadwalkan Sesi',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}