import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String japanese;
  final String chinese;
  final String? romaji;

  const WordCard({
    Key? key,
    required this.japanese,
    required this.chinese,
    this.romaji,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              japanese,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              chinese,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            if (romaji != null) ...[
              const SizedBox(height: 8),
              Text(
                romaji!,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
