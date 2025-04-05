import 'package:flutter/material.dart';
import 'core/home_screen.dart';
import 'features/word_practice_screen.dart';
import 'features/grammar_practice_screen.dart';
import 'features/listening_practice_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/wordPractice': (context) => const WordPracticeScreen(),
        '/grammarPractice': (context) => const GrammarPracticeScreen(),
        '/listeningPractice': (context) => const ListeningPracticeScreen(),
      },
      theme: ThemeData(primarySwatch: Colors.red),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 67, 67),
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image.asset('assets/images/logo.png', width: 200, height: 200),
              const SizedBox(height: 20),
              const Text(
                'Tap to Start',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
