// lib/models/user_model.dart

/// Model ini merepresentasikan data seorang pengguna.
/// Digunakan untuk menyimpan informasi dari Firebase Auth dan Firestore.
class UserModel {
  final String uid;      // ID unik dari Firebase Auth
  final String? email;   // Email pengguna
  final String? displayName; // Nama lengkap pengguna dari Firestore
  final String? photoURL;  // URL foto profil pengguna dari Firestore
  final String? nis;     // Nomor Induk Siswa/Mahasiswa dari Firestore
  final String? role;    // Peran pengguna (misal: 'user', 'admin')

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.nis,
    this.role = 'user', // Default role adalah 'user'
  });

  /// Factory constructor untuk membuat instance UserModel dari data.
  /// Ini adalah pola yang umum untuk mengubah data dari database menjadi objek Dart.
  factory UserModel.fromMap(String uid, String? email, Map<String, dynamic>? data) {
    // Jika data dari firestore null (pengguna baru), isi dengan data minimal.
    if (data == null) {
      return UserModel(uid: uid, email: email);
    }
    // Jika data ada, isi model dengan data lengkap dari firestore.
    // Tanda '??' (null-aware operator) digunakan untuk memberikan nilai default jika data tidak ada.
    return UserModel(
      uid: uid,
      email: email,
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      nis: data['nis'],
      role: data['role'] ?? 'user',
    );
  }
}