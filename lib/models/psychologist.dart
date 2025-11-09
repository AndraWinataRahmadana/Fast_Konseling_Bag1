// lib/models/psychologist.dart
class Psychologist {
  final String id; // Ini adalah NIP/ID Dokumen
  final String uid; // <-- TAMBAHKAN INI (NIK/ID Auth)
  final String name;
  final String specialization;
  final String photoUrl;
  final double rating;

  Psychologist({
    required this.id,
    required this.uid, // <-- TAMBAHKAN INI
    required this.name,
    required this.specialization,
    required this.photoUrl,
    required this.rating,
  });

  factory Psychologist.fromMap(String id, Map<String, dynamic> data) {
    return Psychologist(
      id: id,
      uid: data['uid'] ?? '', // <-- TAMBAHKAN INI
      name: data['name'] ?? 'No Name',
      specialization: data['specialization'] ?? 'No Specialization',
      photoUrl: data['photoUrl'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}