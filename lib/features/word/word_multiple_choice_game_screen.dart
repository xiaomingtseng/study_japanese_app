import 'dart:async';
import 'package:flutter/material.dart';

class WordMultipleChoiceGameScreen extends StatefulWidget {
  final int level;
  final int round;

  const WordMultipleChoiceGameScreen({
    required this.level,
    required this.round,
    super.key,
  });

  @override
  _WordMultipleChoiceGameScreenState createState() =>
      _WordMultipleChoiceGameScreenState();
}

class _WordMultipleChoiceGameScreenState
    extends State<WordMultipleChoiceGameScreen> {
  late List<String> words; // 單字列表
  late String correctAnswer; // 正確答案
  late List<String> options; // 選項
  int currentQuestion = 0; // 當前題目索引
  int score = 0; // 分數
  int totalQuestions = 10; // 總題數
  int timeLeft = 10; // 每題倒數時間
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _generateQuestion();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _generateQuestion() {
    // 模擬單字資料
    words = List.generate(20, (index) => '單字${index + 1}');
    correctAnswer = words[currentQuestion];
    options = List.of(words)..shuffle();
    options = options.take(4).toList();
    if (!options.contains(correctAnswer)) {
      options[0] = correctAnswer;
      options.shuffle();
    }
  }

  void _startTimer() {
    timer?.cancel();
    timeLeft = 10;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    if (currentQuestion < totalQuestions - 1) {
      setState(() {
        currentQuestion++;
        _generateQuestion();
        _startTimer();
      });
    } else {
      timer?.cancel();
      _showResult();
    }
  }

  void _checkAnswer(String answer) {
    if (answer == correctAnswer) {
      score++;
    }
    _nextQuestion();
  }

  void _showResult() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('遊戲結束'),
            content: Text('你的分數是 $score / $totalQuestions'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('確定'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('四選一遊戲 - N${widget.level} 第${widget.round}回')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '題目 ${currentQuestion + 1} / $totalQuestions',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            Text(
              '請選擇正確的單字：$correctAnswer',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Column(
              children:
                  options
                      .map(
                        (option) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8.0,
                          ), // 增加按鈕之間的間距
                          child: ElevatedButton(
                            onPressed: () => _checkAnswer(option),
                            child: Text(option),
                          ),
                        ),
                      )
                      .toList(),
            ),
            const Spacer(),
            Text(
              '剩餘時間：$timeLeft 秒',
              style: const TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
