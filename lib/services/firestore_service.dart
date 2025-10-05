// lib/services/firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fast_konseling/models/psychologist.dart';
import 'package:fast_konseling/models/article.dart';

/// FirestoreService menangani semua operasi baca/tulis ke database Firestore.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mengambil stream daftar psikolog dari Firestore.
  Stream<List<Psychologist>> getPsychologists() {
    return _db.collection('psychologists').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Psychologist.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  /// Mengambil daftar artikel dari Firestore dalam bentuk stream.
  Stream<List<Article>> getArticles() {
    return _db.collection('articles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Article.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  /// Memperbarui atau membuat data pengguna (nama dan NIS) setelah registrasi.
  Future<void> updateUserData({required String name, required String nis}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).set({
        'displayName': name,
        'nis': nis,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error saat update data pengguna: $e");
    }
  }

  /// Memperbarui nama dan NIS/NIM pengguna yang sudah ada di profil.
  Future<void> updateUserProfile({required String newName, required String newNis}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).update({
        'displayName': newName,
        'nis': newNis,
      });
    } catch (e) {
      debugPrint("Error saat update profil: $e");
    }
  }
}