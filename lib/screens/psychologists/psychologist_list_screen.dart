import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/services/firestore_service.dart';
import 'package:fast_konseling/widgets/psychologist_card.dart';

class PsychologistListScreen extends StatelessWidget {
  const PsychologistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Psikolog'),
      ),
      body: StreamProvider<List<Psychologist>>.value(
        value: firestoreService.getPsychologists(),
        initialData: const [],
        child: Consumer<List<Psychologist>>(
          builder: (context, psychologists, child) {
            if (psychologists.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: psychologists.length,
              itemBuilder: (context, index) {
                return PsychologistCard(psychologist: psychologists[index]);
              },
            );
          },
        ),
      ),
    );
  }
}