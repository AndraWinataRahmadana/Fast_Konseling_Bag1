import 'package:flutter/material.dart';

class PsychologistAvatar extends StatelessWidget {
  final String name;
  final String photoUrl;

  const PsychologistAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            backgroundColor: Colors.grey.shade200,
            child: photoUrl.isEmpty ? const Icon(Icons.person, size: 30) : null,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}