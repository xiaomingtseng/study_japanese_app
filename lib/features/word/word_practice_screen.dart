import 'package:flutter/material.dart';
import 'package:study_japanese/features/word/word_list_widget.dart';

class WordPracticeScreen extends StatefulWidget {
  const WordPracticeScreen({super.key});

  @override
  State<WordPracticeScreen> createState() => _WordPracticeScreenState();
}

class _WordPracticeScreenState extends State<WordPracticeScreen> {
  int selectLevel = 5; // 5: N5, 4: N4, 3: N3, 2: N2, 1: N1
  bool isSelectLevel = false; // 是否選擇了等級
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('單字練習')),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    [5, 4, 3, 2, 1]
                        .map(
                          (level) => ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectLevel = level;
                                isSelectLevel = true;
                              });
                            },
                            child: Text('N$level'),
                          ),
                        )
                        .toList(),
              ),
            ),

            if (isSelectLevel)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(height: 300, child: WordList()),
              ),
          ],
        ),
      ),
    );
  }
}
