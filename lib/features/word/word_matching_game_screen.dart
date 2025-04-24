import 'package:flutter/material.dart';
import 'package:study_japanese/core/database/db.dart'; // 假設有一個 Database 類別來處理資料庫操作
import 'package:audioplayers/audioplayers.dart';
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
  final AudioPlayer _effectPlayer = AudioPlayer(); // 初始化音效播放器
  final AudioPlayer _backgroundPlayer = AudioPlayer(); // 背景音樂播放器

  List<Map<String, String>> words = []; // 單字資料
  List<Map<String, String>> cards = []; // 混合的卡片資料
  bool isLoading = true;
  bool isPreviewing = true; // 是否處於單字瀏覽階段
  int correctMatches = 0; // 正確配對數量
  int attempts = 0; // 嘗試次數
  String? selectedJapanese; // 當前選中的日文單字
  String? selectedChinese; // 當前選中的中文翻譯

  late Timer _timer = Timer(const Duration(seconds: 0), () {});
  int _elapsedSeconds = 0; // 已經過的秒數

  @override
  void initState() {
    super.initState();
    _fetchWords();
    _playBackgroundMusic(); // 播放背景音樂
  }

  @override
  void dispose() {
    _stopAndDisposeResources();
    super.dispose();
  }

  void _stopAndDisposeResources() {
    if (!mounted) return; // 如果 Widget 已被移除，直接返回
    if (_timer.isActive) {
      _timer.cancel(); // 停止計時器
    }
    _backgroundPlayer.stop(); // 停止背景音樂
    _backgroundPlayer.dispose(); // 釋放背景音樂播放器資源
    _effectPlayer.dispose(); // 釋放音效播放器資源
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop); // 設定音樂循環播放
      await _backgroundPlayer.setVolume(1); // 設定音量為 50%
      await _backgroundPlayer.play(
        AssetSource('soundtrack/song18.mp3'),
        ctx: AudioContext(
          android: AudioContextAndroid(
            isSpeakerphoneOn: false,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.none, // 不搶占音頻焦點
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.ambient, // 背景播放
            // options: [AVAudioSessionOptions.mixWithOthers], // 與其他音頻混合
          ),
        ),
      ); // 播放背景音樂
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> _playCorrectSound() async {
    try {
      await _effectPlayer.play(AssetSource('soundtrack/correct.mp3')); // 播放正確音效
    } catch (e) {
      print('Error playing correct sound: $e');
    }
  }

  Future<void> _playWrongSound() async {
    try {
      await _effectPlayer.play(AssetSource('soundtrack/wrong.mp3')); // 播放錯誤音效
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  Future<void> _fetchWords() async {
    try {
      // 從資料庫根據分區和回數篩選單字
      final db = Database.instance; // 假設有一個 Database 單例
      final words = await db.fetchWordsByLevelAndRound(
        'N${widget.level}',
        widget.round,
      );

      // 將資料轉換為需要的格式
      final allWords =
          words.map((word) {
            return {
              'japanese': word['word'] as String, // 確保類型為 String
              'chinese': word['mean'] as String, // 確保類型為 String
            };
          }).toList();

      // 隨機挑選 20 個單字
      allWords.shuffle(Random());
      final selectedWords = allWords.take(20).toList();

      setState(() {
        this.words = selectedWords; // 不強制轉換為 Map<String, String>
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
    // 隨機選取 5 個單字進行測驗
    final selectedWords = words.sublist(0, 5);

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
      cards = mixedCards;
      isPreviewing = false;
      _startTimer();
    });
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
        _playCorrectSound(); // 播放正確音效
        correctMatches++;
        cards.removeWhere(
          (card) =>
              (card['type'] == 'japanese' && card['value'] == japanese) ||
              (card['type'] == 'chinese' && card['value'] == chinese),
        );
      } else {
        _playWrongSound(); // 播放錯誤音效
      }
      selectedJapanese = null;
      selectedChinese = null;
    });

    // 停止計時器並顯示遊戲結束畫面
    if (cards.isEmpty) {
      if (_timer.isActive) {
        _timer.cancel(); // 停止計時器
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('單字配對 - N${widget.level} 第 ${widget.round} 回'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/game_back.jpg'), // 設定背景圖片
            fit: BoxFit.cover, // 圖片填滿背景
          ),
        ),
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : isPreviewing
                ? _buildPreviewScreen()
                : cards.isEmpty
                ? _buildGameOverScreen()
                : _buildGameScreen(),
      ),
    );
  }

  Widget _buildPreviewScreen() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            physics: const BouncingScrollPhysics(), // 拖曳效果
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                isPreviewing = false;
                _startGame();
              });
            },
            child: const Text('開始遊戲'),
          ),
        ),
      ],
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('遊戲結束！', style: const TextStyle(fontSize: 24)),
          Text('正確配對數量：$correctMatches', style: const TextStyle(fontSize: 18)),
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
    );
  }

  Widget _buildGameScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 數據顯示區域，添加白底
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8), // 白色背景，帶透明度
              borderRadius: BorderRadius.circular(8.0), // 圓角
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '正確配對數量：$correctMatches',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text('總嘗試次數：$attempts', style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  '計時：${_elapsedSeconds}s',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 卡片區域
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

                      if (selectedJapanese != null && selectedChinese != null) {
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
    );
  }
}
