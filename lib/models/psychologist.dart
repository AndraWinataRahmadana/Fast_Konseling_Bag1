import 'package:flutter/foundation.dart'; // Import ini penting untuk debugPrint

class Psychologist {
  final String id;
  final String name;
  final String specialization;
  final String photoUrl;
  final double rating;

  Psychologist({
    required this.id,
    required this.name,
    required this.specialization,
    required this.photoUrl,
    required this.rating,
  });

  factory Psychologist.fromMap(String id, Map<String, dynamic> data) {

    // --- INI ADALAH KODE MATA-MATA KITA ---
    // Ini akan mencetak isi data mentah ke Debug Console
    debugPrint("DATA MENTAH DARI FIRESTORE UNTUK ID $id: $data");
    // -----------------------------------------

    return Psychologist(
      id: id,
      name: data['name'] ?? 'Nama Tidak Ditemukan', 
      specialization: data['specialization'] ?? '',
      photoUrl: data['photoUrl'] ?? '', 
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}