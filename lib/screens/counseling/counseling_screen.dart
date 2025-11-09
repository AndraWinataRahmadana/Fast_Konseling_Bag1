// lib/screens/counseling/counseling_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/screens/chat/chat_screen.dart';
import 'package:fast_konseling/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Halaman ini menampilkan daftar riwayat chat (sesi konseling)
/// yang dimiliki oleh pengguna.
class CounselingScreen extends StatelessWidget {
  const CounselingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel?>(context);
    final chatService = ChatService();

    if (currentUser == null) {
      return const Center(child: Text('Silakan login terlebih dahulu.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Konseling'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getChatHistory(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Anda belum memulai konseling.'));
          }

          var chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              
              // --- PERBAIKAN ANTI-NULL ---
              // Kita ambil data sebagai Map dinamis dan beri nilai default jika datanya tidak ada.
              final data = chatDocs[index].data() as Map<String, dynamic>? ?? {};

              // Beri nilai default yang aman (bukan null) untuk SETIAP variabel.
              final String psychologistName = data['psychologistName'] as String? ?? 'Psikolog';
              final String psychologistId = data['psychologistId'] as String? ?? '';
              final String lastMessage = data['lastMessage'] as String? ?? '...';

              final Timestamp? timestampData = data['lastMessageTimestamp'] as Timestamp?;
              final DateTime? timestamp = timestampData?.toDate();
              // --- AKHIR PERBAIKAN ---

              return ListTile(
                leading: CircleAvatar(
                  // Tambahkan pengecekan .isNotEmpty
                  child: Text(psychologistName.isNotEmpty ? psychologistName[0].toUpperCase() : 'P'),
                ),
                title: Text(
                  psychologistName, // Dijamin bukan null
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  lastMessage, // Dijamin bukan null
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: timestamp != null
                    ? Text(
                        DateFormat('HH:mm').format(timestamp),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : null,
                onTap: () {
                  // Pastikan ID tidak kosong sebelum pindah halaman
                  if (psychologistId.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          psychologistId: psychologistId,
                          psychologistName: psychologistName,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}