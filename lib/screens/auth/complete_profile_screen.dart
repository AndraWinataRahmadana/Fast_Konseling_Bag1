// lib/screens/auth/complete_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_konseling/services/firestore_service.dart';

/// Halaman ini muncul setelah pengguna pertama kali login
/// untuk melengkapi data nama dan NIS.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nisController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lengkapi Profil Anda'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nisController,
                  decoration: const InputDecoration(
                    labelText: 'NIS / NIM',
                    border: OutlineInputBorder(),
                  ),
                   validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIS/NIM tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await firestoreService.updateUserData(
                        name: _nameController.text,
                        nis: _nisController.text,
                      );
                    }
                  },
                  child: const Text('Simpan & Lanjutkan'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}