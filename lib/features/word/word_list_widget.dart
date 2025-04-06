import 'package:flutter/material.dart';
import 'word_card_widget.dart';

class WordList extends StatelessWidget {
  final List<Map<String, String>> words = [
    {'japanese': 'ありがとう', 'chinese': '謝謝', 'romaji': 'arigatou'},
    {'japanese': 'こんにちは', 'chinese': '你好', 'romaji': 'konnichiwa'},
    {'japanese': 'さようなら', 'chinese': '再見', 'romaji': 'sayounara'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final word = words[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16), // 卡片間距
            child: WordCard(
              japanese: word['japanese']!,
              chinese: word['chinese']!,
              romaji: word['romaji'],
            ),
          );
        },
      ),
    );
  }
}
