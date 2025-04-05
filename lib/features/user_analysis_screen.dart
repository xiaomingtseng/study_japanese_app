import 'package:flutter/material.dart';

class UserAnalysisScreen extends StatelessWidget {
  const UserAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Analysis')),
      body: const Center(
        child: Text('User Analysis Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
