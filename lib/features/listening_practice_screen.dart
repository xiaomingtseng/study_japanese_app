import 'package:flutter/material.dart';

class ListeningPracticeScreen extends StatelessWidget {
  const ListeningPracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('聽力練習')),
      body: const Center(
        child: Text('這是聽力練習頁面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
