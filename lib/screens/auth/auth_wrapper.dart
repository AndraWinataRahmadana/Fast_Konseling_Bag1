// lib/screens/auth/auth_wrapper.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/screens/auth/login_screen.dart';
import 'package:fast_konseling/screens/main_screen.dart';
import 'package:fast_konseling/screens/auth/complete_profile_screen.dart';
import 'package:fast_konseling/screens/psychologists/psychologist_home_screen.dart'; 

/// AuthWrapper bertugas sebagai "penjaga gerbang" aplikasi.
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
    // Berlaku untuk PENGGUNA dan PSIKOLOG
    if (user.nis == null) {
      return const CompleteProfileScreen();
    }

    // 3. Jika profil sudah lengkap, cek peran (role)
    if (user.role == 'psychologist') {
      // 3a. Jika perannya 'psychologist', arahkan ke Dasbor Psikolog
      return const PsychologistHomeScreen();
    } else {
      // 3b. Jika perannya 'user' (atau lainnya), arahkan ke Beranda Pengguna
      return const MainScreen();
    }
  }
}