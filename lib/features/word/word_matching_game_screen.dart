import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class WordMatchingGameScreen extends StatefulWidget {
  final int level; // 等級，例如 N5
  final int round; // 回合，例如第 1 回

  const WordMatchingGameScreen({
    required this.level,
    required this.round,
    super.key,
  });

  @override
  State<WordMatchingGameScreen> createState() => _WordMatchingGameScreenState();
}

class _WordMatchingGameScreenState extends State<WordMatchingGameScreen> {
  List<Map<String, String>> words = []; // 單字資料
  List<Map<String, String>> cards = []; // 混合的卡片資料
  bool isLoading = true;
  int correctMatches = 0; // 正確配對數量
  int attempts = 0; // 嘗試次數
  String? selectedJapanese; // 當前選中的日文單字
  String? selectedChinese; // 當前選中的中文翻譯

  late Timer _timer; // 計時器
  int _elapsedSeconds = 0; // 已經過的秒數

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  @override
  void dispose() {
    _timer.cancel(); // 停止計時器
    super.dispose();
  }

  Future<void> _fetchWords() async {
    try {
      // 模擬從資料庫獲取單字
      final allWords = List.generate(30, (index) {
        return {'japanese': '單字$index', 'chinese': '翻譯$index'};
      });

      // 隨機挑選 8 個單字
      allWords.shuffle(Random());
      final selectedWords = allWords.take(8).toList();

      // 將單字和翻譯混合成卡片
      final japaneseCards =
          selectedWords
              .map((word) => {'type': 'japanese', 'value': word['japanese']!})
              .toList();
      final chineseCards =
          selectedWords
              .map((word) => {'type': 'chinese', 'value': word['chinese']!})
              .toList();

      final mixedCards = [...japaneseCards, ...chineseCards];
      mixedCards.shuffle(Random());

      setState(() {
        words = selectedWords;
        cards = mixedCards;
        isLoading = false;
      });

      // 開始計時
      _startTimer();
    } catch (e) {
      print('Error fetching words: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _checkMatch(String japanese, String chinese) {
    setState(() {
      attempts++;
      final correctWord = words.firstWhere(
        (word) => word['japanese'] == japanese && word['chinese'] == chinese,
        orElse: () => {},
      );
      if (correctWord.isNotEmpty) {
        correctMatches++;
        cards.removeWhere(
          (card) =>
              (card['type'] == 'japanese' && card['value'] == japanese) ||
              (card['type'] == 'chinese' && card['value'] == chinese),
        );
      }
      selectedJapanese = null;
      selectedChinese = null;
    });

    // 停止計時器並顯示遊戲結束畫面
    if (cards.isEmpty) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (cards.isEmpty) {
      // 遊戲結束畫面
      return Scaffold(
        appBar: AppBar(
          title: Text('遊戲結束 - N${widget.level} 第 ${widget.round} 回'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('遊戲結束！', style: const TextStyle(fontSize: 24)),
              Text(
                '正確配對數量：$correctMatches',
                style: const TextStyle(fontSize: 18),
              ),
              Text('總嘗試次數：$attempts', style: const TextStyle(fontSize: 18)),
              Text(
                '所用時間：${_elapsedSeconds}s',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('返回'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('單字配對 - N${widget.level} 第 ${widget.round} 回'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '正確配對數量：$correctMatches',
              style: const TextStyle(fontSize: 18),
            ),
            Text('總嘗試次數：$attempts', style: const TextStyle(fontSize: 18)),
            Text(
              '計時：${_elapsedSeconds}s',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 每行顯示 4 個卡片
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  final isSelected =
                      (card['type'] == 'japanese' &&
                          card['value'] == selectedJapanese) ||
                      (card['type'] == 'chinese' &&
                          card['value'] == selectedChinese);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (card['type'] == 'japanese') {
                          selectedJapanese = card['value'];
                        } else {
                          selectedChinese = card['value'];
                        }

                        if (selectedJapanese != null &&
                            selectedChinese != null) {
                          _checkMatch(selectedJapanese!, selectedChinese!);
                        }
                      });
                    },
                    child: Card(
                      color: isSelected ? Colors.blue[100] : Colors.white,
                      child: Center(
                        child: Text(
                          card['value']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
