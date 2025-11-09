// lib/screens/scheduling/scheduling_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/screens/chat/chat_screen.dart';

/// Halaman ini berfungsi sebagai placeholder untuk proses penjadwalan.
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
              const Text(
                'Fitur pemilihan tanggal dan waktu akan tersedia di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  // --- PERBAIKAN LOGIKA FATAL ADA DI SINI ---
                  // Kita harus mengirim 'psychologist.uid' (NIK/Auth ID) ke ChatScreen,
                  // BUKAN 'psychologist.id' (NIP/Document ID).
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        psychologistId: psychologist.uid, // <-- INI PERBAIKANNYA
                        psychologistName: psychologist.name,
                      ),
                    ),
                  );
                  // --- AKHIR PERBAIKAN ---
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