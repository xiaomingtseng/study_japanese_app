import 'package:flutter/material.dart';

class Katagana extends StatelessWidget {
  const Katagana({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Katagana'),
        backgroundColor: const Color.fromARGB(255, 170, 67, 67),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: KataganaGrid(
          letters: [
            'ア', 'イ', 'ウ', 'エ', 'オ',
            'カ', 'キ', 'ク', 'ケ', 'コ',
            'サ', 'シ', 'ス', 'セ', 'ソ',
            'タ', 'チ', 'ツ', 'テ', 'ト',
            'ナ', 'ニ', 'ヌ', 'ネ', 'ノ',
            'ハ', 'ヒ', 'フ', 'ヘ', 'ホ',
            'マ', 'ミ', 'ム', 'メ', 'モ',
            'ヤ', 'ユ', 'ヨ', '  ', '  ',
            'ラ', 'リ', 'ル', 'レ', 'ロ',
            'ワ', '  ', '  ', '  ', 'ヲ',
            'ン', '  ', '  ', '  ', '  ',
            'ガ', 'ギ', 'グ', 'ゲ', 'ゴ',
            'ザ', 'ジ', 'ズ', 'ゼ', 'ゾ',
            'ダ', 'ヂ', 'ヅ', 'デ', 'ド',
            'パ', 'ピ', 'プ', 'ペ', 'ポ',
            'バ', 'ビ', 'ブ', 'ベ', 'ボ',

            // Add more letters as needed
          ],
        ),
      ),
    );
  }
}

class KataganaGrid extends StatelessWidget {
  final List<String> letters;

  const KataganaGrid({super.key, required this.letters});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        return GridTile(
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 225, 169),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4.0,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                letters[index],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
