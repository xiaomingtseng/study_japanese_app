import 'package:flutter/material.dart';

class Hiragana extends StatelessWidget {
  const Hiragana({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hiragana'),
        backgroundColor: const Color.fromARGB(255, 170, 67, 67),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: HiraganaGrid(
          letters: [
            'あ', 'い', 'う', 'え', 'お',
            'か', 'き', 'く', 'け', 'こ',
            'さ', 'し', 'す', 'せ', 'そ',
            'た', 'ち', 'つ', 'て', 'と',
            'な', 'に', 'ぬ', 'ね', 'の',
            'は', 'ひ', 'ふ', 'へ', 'ほ',
            'ま', 'み', 'む', 'め', 'も',
            'や', 'ゆ', 'よ', '  ', '  ',
            'ら', 'り', 'る', 'れ', 'ろ',
            'わ', 'を', '  ', '  ', '  ',
            'ん', '  ', '  ', '  ', '  ',
            'が', 'ぎ', 'ぐ', 'げ', 'ご',
            'ざ', 'じ', 'ず', 'ぜ', 'ぞ',
            'だ', 'ぢ', 'づ', 'で', 'ど',
            'ぱ', 'ぴ', 'ぷ', 'ぺ', 'ぽ',
            'ば', 'び', 'ぶ', 'べ', 'ぼ',
            // Add more letters as needed
          ],
        ),
      ),
    );
  }
}

class HiraganaGrid extends StatelessWidget {
  final List<String> letters;

  const HiraganaGrid({super.key, required this.letters});

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
              border: Border.all(
                color: const Color.fromARGB(255, 170, 67, 67),
                width: 2.0,
              ),
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
