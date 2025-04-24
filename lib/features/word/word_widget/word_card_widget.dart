import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  final String word; // 必填
  final String? phonetic; // 選填
  final String mean; // 選填

  const WordCard({
    Key? key,
    required this.word, // word 是必填
    this.phonetic, // phonetic 是選填
    required this.mean, // mean 是必填
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              word,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (phonetic != null) ...[
              const SizedBox(height: 8),
              Text(
                phonetic!,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
            if (mean != null) ...[
              const SizedBox(height: 8),
              Text(mean!, style: const TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
