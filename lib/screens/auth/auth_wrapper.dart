// lib/screens/auth/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/screens/auth/login_screen.dart';
import 'package:fast_konseling/screens/main_screen.dart';
import 'package:fast_konseling/screens/auth/complete_profile_screen.dart';

/// AuthWrapper bertugas sebagai "penjaga gerbang" aplikasi.
/// Widget ini menentukan halaman mana yang harus ditampilkan berdasarkan status login
/// dan kelengkapan profil pengguna.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Memantau perubahan pada UserModel dari StreamProvider
    final user = Provider.of<UserModel?>(context);

    // 1. Jika pengguna belum login (user adalah null)
    if (user == null) {
      return const LoginScreen();
    }
    // 2. Jika pengguna sudah login, tapi belum melengkapi profil (NIS masih null)
    else if (user.nis == null) {
      return const CompleteProfileScreen();
    }
    // 3. Jika pengguna sudah login dan profilnya lengkap
    else {
      return const MainScreen();
    }
  }
}