// lib/screens/psychologist/psychologist_home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/screens/chat/chat_screen.dart';
import 'package:fast_konseling/services/auth_service.dart';
import 'package:fast_konseling/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

/// Halaman ini adalah dasbor untuk PSIKOLOG.
class PsychologistHomeScreen extends StatelessWidget {
  const PsychologistHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPsychologist = Provider.of<UserModel?>(context);
    final chatService = ChatService();
    final authService = Provider.of<AuthService>(context, listen: false);

    if (currentPsychologist == null) {
      return const Scaffold(body: Center(child: Text('Gagal memuat data psikolog.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Dasbor Anda, Dr. ${currentPsychologist.displayName ?? "Psikolog"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getChatHistory(currentPsychologist.uid),
        builder: (context, snapshot) {
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada antrian konseling.'));
          }

          var chatDocs = snapshot.data!.docs; 

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              
              // --- PERBAIKAN PALING AMAN (ANTI-NULL) ---
              final data = chatDocs[index].data() as Map<String, dynamic>? ?? {};

              // Beri nilai default yang aman (bukan null) untuk SETIAP variabel.
              // Kita gunakan `as String?` untuk cast yang aman, lalu `??` untuk nilai default.
              final String userName = data['userName'] as String? ?? 'Pengguna';
              final String userId = data['userId'] as String? ?? '';
              final String userPhotoUrl = data['userPhotoUrl'] as String? ?? '';
              final String lastMessage = data['lastMessage'] as String? ?? '...';
              final String lastMessageSenderId = data['lastMessageSenderId'] as String? ?? '';
              
              final Timestamp? timestampData = data['lastMessageTimestamp'] as Timestamp?;
              final DateTime? timestamp = timestampData?.toDate();
              
              final bool isUnread = lastMessageSenderId == userId && userId.isNotEmpty;
              // --- AKHIR PERBAIKAN ---

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: userPhotoUrl.isNotEmpty ? NetworkImage(userPhotoUrl) : null,
                  child: userPhotoUrl.isEmpty 
                         ? Text(userName.isNotEmpty ? userName[0].toUpperCase() : 'P') 
                         : null,
                ),
                title: Text(
                  userName, // Dijamin 100% bukan null
                  style: TextStyle(
                    fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  lastMessage, // Dijamin 100% bukan null
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: timestamp != null
                    ? Text(
                        DateFormat('HH:mm').format(timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: isUnread ? Colors.blue : Colors.grey,
                        ),
                      )
                    : null,
                onTap: () {
                  if (userId.isNotEmpty) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          psychologistId: userId,
                          psychologistName: userName,
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