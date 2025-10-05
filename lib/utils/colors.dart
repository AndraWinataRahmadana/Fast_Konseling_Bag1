// lib/utils/colors.dart

import 'package:flutter/material.dart';

/// Kelas ini berisi definisi palet warna yang digunakan di seluruh aplikasi
/// untuk menjaga konsistensi visual.
class AppColors {
  // Warna utama yang digunakan untuk AppBar, tombol, dan elemen penting lainnya.
  static const Color primaryColor = Color(0xFF4A90E2); // Biru yang Tenang
  
  // Warna aksen untuk menyorot elemen interaktif atau sekunder.
  static const Color secondaryColor = Color(0xFF50E3C2); // Hijau Mint
  
  // Warna latar belakang utama untuk sebagian besar layar.
  static const Color backgroundColor = Color(0xFFF4F6F8); // Abu-abu Sangat Terang

  // Warna untuk kartu (Card) agar sedikit berbeda dari latar belakang.
  static const Color cardColor = Colors.white;

  // Warna untuk teks utama.
  static const Color textColor = Color(0xFF333333); // Abu-abu Gelap

  // MaterialColor diperlukan untuk beberapa widget Flutter seperti ThemeData.
  static const MaterialColor primaryMaterialColor = MaterialColor(
    0xFF4A90E2,
    <int, Color>{
      50: Color(0xFFE9F2FC),
      100: Color(0xFFC9DFF8),
      200: Color(0xFFA5CBF3),
      300: Color(0xFF81B7EE),
      400: Color(0xFF66A7EA),
      500: Color(0xFF4A90E2), // Nilai utama
      600: Color(0xFF4388DE),
      700: Color(0xFF3A7DD9),
      800: Color(0xFF3271D4),
      900: Color(0xFF235FD0),
    },
  );
}