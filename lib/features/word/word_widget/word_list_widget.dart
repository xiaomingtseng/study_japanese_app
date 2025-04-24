import 'package:flutter/material.dart';
import 'word_card_widget.dart';
import '../../../core/database/db.dart';

class WordList extends StatefulWidget {
  final String jlptLevel; // 傳入的 JLPT 分級

  const WordList({Key? key, required this.jlptLevel}) : super(key: key);

  @override
  _WordListState createState() => _WordListState();
}

class _WordListState extends State<WordList> {
  List<Map<String, dynamic>> words = []; // 儲存從資料庫獲取的單字資料
  bool isLoading = true; // 加載狀態

  @override
  void initState() {
    super.initState();
    _fetchWords(); // 初始化時從資料庫獲取資料
  }

  Future<void> _fetchWords() async {
    try {
      final db = Database.instance;

      final fetchedWords = await db.fetchWords(widget.jlptLevel); // 從資料庫獲取資料
      setState(() {
        words = fetchedWords;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching words: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('單字卡片')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator()) // 顯示加載指示器
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16), // 卡片間距
                    child: WordCard(
                      word: word['word'] ?? '', // 單字
                      phonetic: word['phonetic'], // 音標
                      mean: word['mean'], // 意思
                      // 這裡可以添加更多的屬性，例如例句等
                    ),
                  );
                },
              ),
    );
  }
}
