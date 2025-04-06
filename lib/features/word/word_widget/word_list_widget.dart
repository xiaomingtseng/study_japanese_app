import 'package:flutter/material.dart';
import 'word_card_widget.dart';

class WordList extends StatelessWidget {
  final List<Map<String, String>> words = [
    {'japanese': 'ありがとう', 'chinese': '謝謝', 'romaji': 'arigatou'},
    {'japanese': 'こんにちは', 'chinese': '你好', 'romaji': 'konnichiwa'},
    {'japanese': 'さようなら', 'chinese': '再見', 'romaji': 'sayounara'},
    {'japanese': 'おはよう', 'chinese': '早安', 'romaji': 'ohayou'},
    {'japanese': 'こんばんは', 'chinese': '晚安', 'romaji': 'konbanwa'},
    {'japanese': 'すみません', 'chinese': '對不起', 'romaji': 'sumimasen'},
    {'japanese': 'はい', 'chinese': '是', 'romaji': 'hai'},
    {'japanese': 'いいえ', 'chinese': '不是', 'romaji': 'iie'},
    {'japanese': 'お願いします', 'chinese': '拜託', 'romaji': 'onegai shimasu'},
    {'japanese': 'どういたしまして', 'chinese': '不客氣', 'romaji': 'douitashimashite'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('單字卡片')),
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
