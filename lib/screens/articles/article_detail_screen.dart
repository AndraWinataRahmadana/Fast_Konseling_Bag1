// lib/screens/articles/article_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:fast_konseling/models/article.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal. Pastikan Anda punya package intl di pubspec.yaml

/// Halaman untuk menampilkan detail lengkap dari sebuah artikel.
class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Artikel
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                article.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Judul Artikel
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            // Informasi Penulis dan Tanggal
            Text(
              'Oleh ${article.author} | ${DateFormat('dd MMMM yyyy').format(article.publishDate)}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 25),
            // Isi Konten Artikel
            Text(
              article.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6, // Jarak antar baris
              ),
              textAlign: TextAlign.justify, // Rata kanan-kiri
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}