import 'package:flutter/material.dart';
import 'package:study_japanese/core/database/db.dart';
import 'package:study_japanese/features/word/word_matching_game_screen.dart';
import 'package:study_japanese/features/word/word_multiple_choice_game_screen.dart';

class SectionQuizSelectionScreen extends StatefulWidget {
  final int level; // 傳入的等級，例如 N5

  const SectionQuizSelectionScreen({required this.level, super.key});

  @override
  State<SectionQuizSelectionScreen> createState() =>
      _SectionQuizSelectionScreenState();
}

class _SectionQuizSelectionScreenState
    extends State<SectionQuizSelectionScreen> {
  int totalRounds = 0; // 總回數
  bool isLoading = true; // 是否正在加載

  @override
  void initState() {
    super.initState();
    _calculateRounds();
  }

  Future<void> _calculateRounds() async {
    try {
      final db = Database.instance;
      final jlptLevel = 'N${widget.level}'; // 例如 N5
      final words = await db.fetchWords(jlptLevel); // 獲取該集合的所有單字
      setState(() {
        totalRounds = (words.length / 20).ceil(); // 每 20 個單字為一回，向上取整
        isLoading = false;
      });
    } catch (e) {
      print('Error calculating rounds: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final rounds = List.generate(totalRounds, (index) => '第 ${index + 1} 回');

    return Scaffold(
      appBar: AppBar(title: Text('分區測驗 - N${widget.level}')),
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
                                    level: widget.level,
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
                                    level: widget.level,
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
