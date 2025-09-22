import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/services/firestore_service.dart';
import 'package:fast_konseling/widgets/psychologist_avatar.dart';
import 'package:fast_konseling/widgets/article_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    final String displayName = user?.email?.split('@').first ?? 'Pengguna';
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Fast Konseling', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey[800]),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang, $displayName!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Apa yang ingin Anda lakukan hari ini?',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari psikolog atau topik...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Psikolog Unggulan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: StreamBuilder<List<Psychologist>>(
                  stream: firestoreService.getPsychologists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Gagal memuat data'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Belum ada psikolog'));
                    }
                    final psychologists = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: psychologists.length,
                      itemBuilder: (context, index) {
                        final psychologist = psychologists[index];
                        return PsychologistAvatar(
                          name: psychologist.name.split(',').first,
                          photoUrl: psychologist.photoUrl,
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Artikel & Tips untuk Anda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const ArticleCard(
                title: '5 Cara Mengelola Stres di Sekolah',
                subtitle: 'Temukan Strategi Praktis Agar Bersekolah Lebih Tenang.',
                color: Colors.blue,
              ),
              const ArticleCard(
                title: 'Memahami Pentingnya Self-Reward',
                subtitle: 'Mulai perjalanan untuk memberi hadiah untuk diri sendiri hari ini.',
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}