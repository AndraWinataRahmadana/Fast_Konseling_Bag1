// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/screens/home/home_screen.dart';
import 'package:fast_konseling/screens/counseling/counseling_screen.dart';
import 'package:fast_konseling/screens/psychologists/psychologist_list_screen.dart';
import 'package:fast_konseling/screens/profile/profile_screen.dart';

/// MainScreen adalah widget utama yang menampung BottomNavigationBar
/// dan halaman-halaman utama setelah pengguna login.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // State untuk melacak tab yang sedang aktif
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai tab yang dipilih
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CounselingScreen(),
    PsychologistListScreen(),
    ProfileScreen(),
  ];

  // Fungsi yang dipanggil saat item di navbar ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman yang sesuai dengan _selectedIndex
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        // Dekorasi untuk memberi batas atas (border) pada navbar
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Konseling',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Psikolog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed, // Tipe agar semua label terlihat
          onTap: _onItemTapped,
          elevation: 0, // Hilangkan shadow default karena sudah pakai border
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}