import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 如果您使用 Firebase CLI 生成了配置文件
import 'features/home_screen.dart';
import 'features/fifty_letter/hiragana.dart';
import 'features/fifty_letter/katagana.dart';
import 'features/word/word_practice_screen.dart';
import 'features/grammer/grammar_practice_screen.dart';
import 'features/listening_practice_screen.dart';
import 'features/user_analysis_screen.dart';
import 'features/setting_screen.dart';
import 'features/news/news_screen.dart';
import 'features/news/news_detail_screen.dart';
import 'core/http/news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // 如果使用 Firebase CLI 配置
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study Japanese',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/katagana': (context) => const Katagana(),
        '/hiragana': (context) => const Hiragana(),
        '/wordPractice': (context) => const WordPracticeScreen(),
        '/grammarPractice': (context) => const GrammarPracticeScreen(),
        '/listeningPractice': (context) => const ListeningPracticeScreen(),
        '/userAnalysis': (context) => const UserAnalysisScreen(),
        '/setting': (context) => const SettingScreen(),
        '/news': (context) => NewsScreen(),
        '/newsDetail': (context) => NewsDetailScreen(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
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
