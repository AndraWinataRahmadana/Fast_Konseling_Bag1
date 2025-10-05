// lib/screens/psychologists/psychologist_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/screens/scheduling/scheduling_screen.dart';

/// Halaman ini menampilkan detail informasi dari seorang psikolog.
class PsychologistDetailScreen extends StatelessWidget {
  final Psychologist psychologist;

  const PsychologistDetailScreen({super.key, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(psychologist.name),
        // Menambahkan tombol Share di AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality (e.g., using the 'share_plus' package)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur berbagi akan datang!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ... (Kode untuk menampilkan foto, nama, spesialisasi, rating - tidak berubah) ...
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: psychologist.photoUrl.isNotEmpty
                  ? NetworkImage(psychologist.photoUrl)
                  : null,
              child: psychologist.photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              psychologist.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              psychologist.specialization,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  psychologist.rating.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Tombol "Jadwalkan Sesi" kini mengarah ke SchedulingScreen
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigasi ke halaman penjadwalan, bukan lagi ke chat
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SchedulingScreen(psychologist: psychologist),
                    ),
                  );
                },
                child: const Text('Jadwalkan Sesi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}