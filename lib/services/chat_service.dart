import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Membuat atau mendapatkan ID ruang obrolan yang unik
  String getChatRoomId(String psychologistId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("Pengguna belum login");

    // Urutkan ID untuk memastikan konsistensi
    List<String> ids = [currentUser.uid, psychologistId];
    ids.sort();
    return ids.join('_');
  }

  // Mengirim pesan
  Future<void> sendMessage(String chatRoomId, String messageText) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || messageText.trim().isEmpty) return;

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUser.uid,
      'text': messageText,
      'timestamp': Timestamp.now(),
    });
  }

  // Mendapatkan stream pesan dari ruang obrolan
  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}