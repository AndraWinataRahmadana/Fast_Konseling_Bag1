// lib/services/auth_service.dart

// Import package dasar dari Firebase dan Google Sign-In.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:flutter/foundation.dart';

/// AuthService menangani semua logika terkait autentikasi pengguna.
class AuthService {
  // Instance dari service Firebase yang akan kita gunakan.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream yang memberikan UserModel saat status autentikasi berubah.
  /// Ini adalah cara modern untuk memantau status login secara real-time.
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((User? firebaseUser) async {
      if (firebaseUser == null) {
        return null;
      }
      // Jika ada pengguna, ambil data lengkapnya dari dokumen di Firestore.
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      // Buat objek UserModel dari data Firebase Auth dan data Firestore.
      return UserModel.fromMap(firebaseUser.uid, firebaseUser.email, userDoc.data());
    });
  }

  /// Memulai proses login dengan Google.
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Memulai alur pop-up Google Sign-In.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Pengguna membatalkan proses.
      }

      // 2. Mendapatkan detail autentikasi (token) dari request.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Membuat kredensial Firebase dari token Google.
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Login ke Firebase dengan kredensial tersebut.
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // 5. Jika ini adalah pengguna baru, buat dokumen baru untuk mereka di Firestore.
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL, // Simpan URL foto dari akun Google.
            'createdAt': FieldValue.serverTimestamp(),
            'role': 'user',
            'nis': null,
          });
        }
      }
      return user;
    } catch (e) {
      debugPrint("Error saat login dengan Google: $e");
      return null;
    }
  }

  /// Mendaftarkan pengguna baru dengan Email dan Password.
  Future<UserModel?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'displayName': null,
          'photoURL': null, // Pengguna email tidak punya foto default.
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user',
          'nis': null,
        });
      }
      return UserModel(uid: user!.uid, email: user.email);
    } catch (e) {
      debugPrint("Error saat registrasi: $e");
      return null;
    }
  }
  
  /// Login pengguna dengan Email dan Password yang sudah terdaftar.
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return UserModel(uid: user!.uid, email: user.email);
    } catch (e) {
      debugPrint("Error saat login dengan email: $e");
      return null;
    }
  }

  /// Proses logout dari Firebase dan Google Sign-In.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Error saat logout: $e");
    }
  }
}