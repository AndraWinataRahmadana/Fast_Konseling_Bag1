// lib/screens/chat/chat_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ChatScreen adalah halaman antarmuka obrolan antara pengguna dan psikolog.
class ChatScreen extends StatefulWidget {
  final String psychologistId;
  final String psychologistName;

  const ChatScreen({
    super.key,
    required this.psychologistId,
    required this.psychologistName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Controller untuk field input pesan
  final TextEditingController _messageController = TextEditingController();
  // Instance dari ChatService untuk mengelola logika chat
  final ChatService _chatService = ChatService();
  // ID unik untuk ruang obrolan ini
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    // Membuat ID ruang obrolan saat halaman pertama kali dimuat
    chatRoomId = _chatService.getChatRoomId(widget.psychologistId);
  }

  /// Fungsi untuk mengirim pesan.
  void _sendMessage() {
    // Memanggil fungsi dari ChatService
    _chatService.sendMessage(chatRoomId, _messageController.text);
    // Mengosongkan field input setelah pesan terkirim
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan data pengguna yang sedang login
    final currentUser = Provider.of<UserModel?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.psychologistName),
      ),
      body: Column(
        children: [
          // Bagian untuk menampilkan daftar pesan
          Expanded(
            child: StreamBuilder(
              stream: _chatService.getMessages(chatRoomId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Terjadi kesalahan"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Tampilkan pesan dalam ListView
                return ListView(
                  reverse: true, // Pesan terbaru muncul di bawah
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    // Cek apakah pesan ini dikirim oleh pengguna saat ini
                    bool isMe = data['senderId'] == currentUser?.uid;
                    var alignment = isMe ? Alignment.centerRight : Alignment.centerLeft;
                    // Widget untuk bubble chat
                    return Container(
                      alignment: alignment,
                      child: Card(
                        color: isMe ? Theme.of(context).primaryColorLight : Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(data['text']),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          // Bagian input untuk mengetik pesan
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// Widget untuk membangun field input pesan dan tombol kirim.
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "Ketik pesan...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}