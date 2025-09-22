import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/models/user_model.dart';
import 'package:fast_konseling/screens/auth/login_screen.dart';
import 'package:fast_konseling/screens/main_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      return const LoginScreen();
    } else {
      return const MainScreen();
    }
  }
}