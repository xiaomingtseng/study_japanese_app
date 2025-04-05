import 'package:flutter/material.dart';

class GrammarPracticeScreen extends StatelessWidget {
  const GrammarPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('文法練習')),
      body: Center(child: Text('這是文法練習頁面', style: TextStyle(fontSize: 24))),
    );
  }
}
