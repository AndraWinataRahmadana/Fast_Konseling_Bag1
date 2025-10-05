// lib/screens/scheduling/scheduling_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/screens/chat/chat_screen.dart';

/// Halaman ini berfungsi sebagai placeholder untuk proses penjadwalan.
/// Di masa depan, halaman ini bisa berisi kalender untuk memilih tanggal dan waktu.
class SchedulingScreen extends StatelessWidget {
  final Psychologist psychologist;

  const SchedulingScreen({super.key, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Jadwal Sesi'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Informasi psikolog yang dipilih
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(psychologist.photoUrl),
              ),
              const SizedBox(height: 16),
              Text(
                psychologist.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                psychologist.specialization,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              // Placeholder untuk pilihan tanggal dan waktu
              const Text(
                'Fitur pemilihan tanggal dan waktu akan tersedia di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              // Tombol untuk konfirmasi dan memulai chat
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  // Setelah "konfirmasi", arahkan ke halaman chat
                  Navigator.of(context).pushReplacement( // pushReplacement agar tidak bisa kembali ke halaman jadwal
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        psychologistId: psychologist.id,
                        psychologistName: psychologist.name,
                      ),
                    ),
                  );
                },
                child: const Text('Konfirmasi & Mulai Konseling'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}