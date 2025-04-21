import 'package:flutter/material.dart';
import 'package:study_japanese/features/word/word_widget/word_list_widget.dart';
import 'package:study_japanese/features/word/section_quiz_selection_screen.dart';

class WordPracticeScreen extends StatefulWidget {
  const WordPracticeScreen({super.key});

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('單字練習'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'N5'),
            Tab(text: 'N4'),
            Tab(text: 'N3'),
            Tab(text: 'N2'),
            Tab(text: 'N1'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            [5, 4, 3, 2, 1].map((level) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 單字卡複習按鈕
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => WordList(jlptLevel: 'N$level'),
                              ),
                            );
                          },
                          child: const Text('單字卡複習'),
                        ),

                        // 隨機測驗按鈕
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => RandomQuizScreen(level: level),
                              ),
                            );
                          },
                          child: const Text('隨機測驗'),
                        ),

                        // 分區測驗按鈕
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SectionQuizSelectionScreen(
                                      level: level,
                                    ),
                              ),
                            );
                          },
                          child: const Text('分區測驗'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

// 單字卡複習頁面
class WordCardReviewScreen extends StatelessWidget {
  final int level;
  const WordCardReviewScreen({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('單字卡複習 - N$level')),
      body: Center(child: Text('這裡是單字卡複習功能，等級：N$level')),
    );
  }
}

// 隨機測驗頁面
class RandomQuizScreen extends StatelessWidget {
  final int level;
  const RandomQuizScreen({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('隨機測驗 - N$level')),
      body: Center(child: Text('這裡是隨機測驗功能，等級：N$level')),
    );
  }
}

// 分區測驗頁面
class SectionQuizScreen extends StatelessWidget {
  final int level;
  const SectionQuizScreen({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('分區測驗 - N$level')),
      body: Center(child: Text('這裡是分區測驗功能，等級：N$level')),
    );
  }
}
