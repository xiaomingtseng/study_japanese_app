import 'dart:async';
import 'package:flutter/material.dart';
import 'package:study_japanese/core/database/db.dart'; // 假設有一個 Database 類別來處理資料庫操作
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer _effectPlayer = AudioPlayer(); // 初始化音效播放器

  List<Map<String, String>> words = []; // 單字資料
  late String correctAnswer; // 正確答案
  late List<String> options; // 選項
  int currentQuestion = 0; // 當前題目索引
  int score = 0; // 分數
  int totalQuestions = 10; // 總題數
  int timeLeft = 10; // 每題倒數時間
  late Timer timer = Timer(const Duration(seconds: 0), () {});

  bool isPreviewing = true; // 是否處於單字預覽階段
  bool isLoading = true; // 是否正在加載單字

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  @override
  void dispose() {
    _effectPlayer.dispose(); // 釋放音效播放器資源
    timer.cancel();
    super.dispose();
  }

  Future<void> _fetchWords() async {
    try {
      final db = Database.instance; // 假設有一個 Database 單例
      final fetchedWords = await db.fetchWordsByLevelAndRound(
        'N${widget.level}', // 根據等級篩選，例如 N5
        widget.round, // 根據回數篩選
      );

      // 將資料轉換為需要的格式
      final allWords =
          fetchedWords.map((word) {
            return {
              'japanese': word['word'] as String,
              'chinese': word['mean'] as String,
            };
          }).toList();

      setState(() {
        words = allWords;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching words: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startGame() {
    _generateQuestion();
    _startTimer();
    setState(() {
      isPreviewing = false; // 結束單字預覽階段
    });
  }

  void _generateQuestion() {
    final currentWord = words[currentQuestion];
    correctAnswer = currentWord['japanese']!;
    options = List.of(words.map((word) => word['japanese']!))..shuffle();
    options = options.take(4).toList();
    if (!options.contains(correctAnswer)) {
      options[0] = correctAnswer;
      options.shuffle();
    }
  }

  void _startTimer() {
    timer.cancel();
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
      timer.cancel();
      _showResult();
    }
  }

  // 播放正確音效
  Future<void> _playCorrectSound() async {
    try {
      await _effectPlayer.play(
        AssetSource('soundtrack/correct.mp3'),
        volume: 1.0,
      ); // 播放正確音效
    } catch (e) {
      print('Error playing correct sound: $e');
    }
  }

  // 播放錯誤音效
  Future<void> _playWrongSound() async {
    try {
      await _effectPlayer.play(
        AssetSource('soundtrack/wrong.mp3'),
        volume: 1.0,
      ); // 播放錯誤音效
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  void _checkAnswer(String answer) {
    if (answer == correctAnswer) {
      _playCorrectSound(); // 播放正確音效
      score++;
    } else {
      _playWrongSound(); // 播放錯誤音效
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
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isPreviewing) {
      // 單字預覽階段
      return Scaffold(
        appBar: AppBar(
          title: Text('單字預覽 - N${widget.level} 第${widget.round}回'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/game_back.jpg'), // 設定背景圖片
              fit: BoxFit.cover, // 圖片填滿背景
            ),
          ),
          child: PageView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Center(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          word['japanese']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          word['chinese']!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startGame,
          child: const Icon(Icons.play_arrow),
        ),
      );
    }

    // 遊戲階段
    return Scaffold(
      appBar: AppBar(title: Text('四選一遊戲 - N${widget.level} 第${widget.round}回')),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/game_back.jpg'), // 設定背景圖片
            fit: BoxFit.cover, // 圖片填滿背景
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '題目 ${currentQuestion + 1} / $totalQuestions',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16.0),
              // 固定題目區域高度並支持滑動
              Container(
                height: 150, // 固定高度
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    '${words[currentQuestion]['chinese']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // 選項區域
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _checkAnswer(option),
                        child: Text(option),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              // 倒數計時進度條
              Container(
                height: 20, // 進度條高度
                decoration: BoxDecoration(
                  color: Colors.white, // 白色背景
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: LinearProgressIndicator(
                    value: timeLeft / 10, // 設定進度條的值
                    backgroundColor: Colors.grey[300], // 進度條背景顏色
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.red,
                    ), // 進度條顏色
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
