// lib/models/article.dart

/// Model untuk merepresentasikan sebuah artikel atau tips.
class Article {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl; // URL gambar untuk kartu artikel
  final String content;  // Isi lengkap artikel (bisa berupa HTML, Markdown, atau plain text)
  final String author;
  final DateTime publishDate;

  Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.content,
    required this.author,
    required this.publishDate,
  });

  /// Factory constructor untuk membuat objek Article dari Map (data Firestore).
  factory Article.fromMap(String id, Map<String, dynamic> data) {
    return Article(
      id: id,
      title: data['title'] ?? 'No Title',
      subtitle: data['subtitle'] ?? 'No Subtitle',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // Placeholder jika tidak ada
      content: data['content'] ?? 'Isi artikel tidak tersedia.',
      author: data['author'] ?? 'Anonim',
      publishDate: (data['publishDate'] != null)
          ? DateTime.parse(data['publishDate']) // Asumsi publishDate disimpan sebagai String ISO 8601
          : DateTime.now(),
    );
  }
}