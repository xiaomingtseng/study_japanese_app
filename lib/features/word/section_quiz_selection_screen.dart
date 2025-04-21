import 'package:flutter/material.dart';
import 'package:study_japanese/features/word/word_matching_game_screen.dart';
import 'package:study_japanese/features/word/word_multiple_choice_game_screen.dart';

class SectionQuizSelectionScreen extends StatelessWidget {
  final int level; // 傳入的等級，例如 N5

  const SectionQuizSelectionScreen({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    // 假設每個等級有 5 回
    final rounds = List.generate(5, (index) => '第 ${index + 1} 回');

    return Scaffold(
      appBar: AppBar(title: Text('分區測驗 - N$level')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: rounds.length,
        itemBuilder: (context, index) {
          final round = rounds[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    round,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 進入單字配對遊戲
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WordMatchingGameScreen(
                                    level: level,
                                    round: index + 1,
                                  ),
                            ),
                          );
                        },
                        child: const Text('單字配對遊戲'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // 進入四選一遊戲
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WordMultipleChoiceGameScreen(
                                    level: level,
                                    round: index + 1,
                                  ),
                            ),
                          );
                        },
                        child: const Text('選擇題遊戲'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
