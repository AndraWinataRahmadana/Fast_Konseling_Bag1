// lib/main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/firebase_options.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/services/auth_service.dart';
import 'package:fast_konseling/services/firestore_service.dart';
import 'package:fast_konseling/screens/welcome_screen.dart';
import 'package:fast_konseling/utils/colors.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();
  // Menginisialisasi Firebase dengan konfigurasi platform saat ini
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider menyediakan berbagai service ke seluruh widget tree
    return MultiProvider(
      providers: [
        // Menyediakan instance AuthService
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Menyediakan instance FirestoreService
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        // StreamProvider memantau status login pengguna secara real-time
        StreamProvider<UserModel?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Fast Konseling',
        theme: ThemeData(
          // Menggunakan palet warna baru
          primarySwatch: AppColors.primaryMaterialColor,
          scaffoldBackgroundColor: AppColors.backgroundColor,
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        // Aplikasi dimulai dari WelcomeScreen
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}