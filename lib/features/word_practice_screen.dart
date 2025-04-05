import 'package:flutter/material.dart';

class WordPracticeScreen extends StatelessWidget {
  const WordPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('單字練習')),
      body: const Center(
        child: Text('這是單字練習頁面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
