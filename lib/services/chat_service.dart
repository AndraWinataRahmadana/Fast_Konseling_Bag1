// lib/services/chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service ini mengelola semua logika terkait obrolan (chat).
class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mendapatkan ID unik untuk ruang obrolan (chat room).
  String getChatRoomId(String otherUserId) {
    final currentUserId = _auth.currentUser!.uid;
    // Urutkan ID agar konsisten
    return currentUserId.hashCode <= otherUserId.hashCode
        ? '${currentUserId}_${otherUserId}'
        : '${otherUserId}_${currentUserId}';
  }

  /// Mengirim pesan baru ke chat room.
  /// INI ADALAH FUNGSI YANG SUDAH DIPERBARUI UNTUK MENERIMA NAMED PARAMETERS
  Future<void> sendMessage(
    String chatRoomId,
    String message, {
    // Parameter tambahan untuk metadata (wajib ada)
    required String psychologistId,
    required String psychologistName,
    required String userId,
    required String userName,
    String? userPhotoUrl,
  }) async {
    // Dapatkan ID dan email pengguna saat ini (yang mengirim pesan)
    final currentUserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // 1. Buat dokumen pesan baru di dalam sub-koleksi 'messages'
    await _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'text': message,
      'timestamp': timestamp,
    });

    // 2. PERBARUI DOKUMEN CHAT ROOM (METADATA)
    // Ini akan membuat/memperbarui info ringkas dari chat room
    await _db.collection('chat_rooms').doc(chatRoomId).set(
      {
        'participants': [userId, psychologistId], // Daftar ID peserta
        'lastMessage': message,
        'lastMessageTimestamp': timestamp,
        'lastMessageSenderId': currentUserId,
        
        // Menyimpan info kedua belah pihak agar mudah diambil
        'userId': userId,
        'userName': userName,
        'userPhotoUrl': userPhotoUrl ?? '',
        'psychologistId': psychologistId,
        'psychologistName': psychologistName,
      },
      SetOptions(merge: true), // 'merge: true' agar tidak menimpa data yang ada
    );
  }

  /// Mendapatkan stream (aliran data) dari pesan-pesan dalam chat room.
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Mendapatkan stream dari riwayat chat untuk pengguna (atau psikolog)
  Stream<QuerySnapshot> getChatHistory(String userId) {
    return _db
        .collection('chat_rooms')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots();
  }
}