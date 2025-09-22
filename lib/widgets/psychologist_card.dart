import 'package:flutter/material.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/screens/psychologists/psychologist_detail_screen.dart';

class PsychologistCard extends StatelessWidget {
  final Psychologist psychologist;

  const PsychologistCard({super.key, required this.psychologist});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12.0),
        leading: CircleAvatar(
          radius: 30,
          // Menambahkan pengecekan jika URL kosong
          backgroundImage: psychologist.photoUrl.isNotEmpty
              ? NetworkImage(psychologist.photoUrl)
              : null,
          // Menampilkan ikon jika tidak ada gambar
          child: psychologist.photoUrl.isEmpty
              ? const Icon(Icons.person, size: 30)
              : null,
          backgroundColor: Colors.grey.shade200,
        ),
        title: Text(psychologist.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(psychologist.specialization),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 4),
            Text(psychologist.rating.toString()),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => PsychologistDetailScreen(psychologist: psychologist),
            ),
          );
        },
      ),
    );
  }
}