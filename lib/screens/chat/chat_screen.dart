// lib/screens/chat/chat_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  // ID dari pihak lawan bicara.
  final String psychologistId;
  // Nama dari pihak lawan bicara.
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
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();
  late String chatRoomId;

  @override
  void initState() {
    super.initState();
    // Membuat ID ruang obrolan saat halaman pertama kali dimuat.
    chatRoomId = _chatService.getChatRoomId(widget.psychologistId);
  }

  /// Fungsi untuk mengirim pesan.
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    // Ambil data pengguna saat ini (bisa jadi pengguna atau psikolog)
    final currentUser = Provider.of<UserModel?>(context, listen: false);
    if (currentUser == null) return;

    // --- INI ADALAH LOGIKA YANG DIPERBAIKI ---
    String userId, userName, userPhotoUrl, psychologistId, psychologistName;

    if (currentUser.role == 'psychologist') {
      // Jika yang mengirim adalah PSIKOLOG:
      psychologistId = currentUser.uid;
      psychologistName = currentUser.displayName ?? 'Psikolog';
      // Lawan bicaranya adalah si pengguna (pasien)
      userId = widget.psychologistId;
      userName = widget.psychologistName;
      userPhotoUrl = ''; // Foto pasien tidak perlu kita simpan di sini
    } else {
      // Jika yang mengirim adalah PENGGUNA:
      userId = currentUser.uid;
      userName = currentUser.displayName ?? 'Pengguna';
      userPhotoUrl = currentUser.photoURL ?? '';
      // Lawan bicaranya adalah si psikolog
      psychologistId = widget.psychologistId;
      psychologistName = widget.psychologistName;
    }

    // Panggil fungsi sendMessage dari ChatService dengan parameter bernama
    _chatService.sendMessage(
      chatRoomId,
      _messageController.text.trim(),
      // 'userId' dan 'psychologistId' sekarang sudah didefinisikan
      userId: userId,
      userName: userName,
      userPhotoUrl: userPhotoUrl,
      psychologistId: psychologistId,
      psychologistName: psychologistName,
    );
    // --- AKHIR PERBAIKAN ---

    _messageController.clear();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.psychologistName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatService.getMessages(chatRoomId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Terjadi kesalahan"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(10.0),
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    bool isMe = data['senderId'] == currentUser?.uid;

                    var alignment =
                        isMe ? Alignment.centerRight : Alignment.centerLeft;
                    var bubbleColor =
                        isMe ? Theme.of(context).primaryColorLight : Colors.white;
                    var textColor = isMe ? Colors.black87 : Colors.black87;

                    return Container(
                      alignment: alignment,
                      child: Card(
                        color: bubbleColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            data['text'],
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  /// Widget untuk membangun field input pesan dan tombol kirim.
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onSubmitted: (value) => _sendMessage(),
              decoration: const InputDecoration(
                hintText: "Ketik pesan...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}