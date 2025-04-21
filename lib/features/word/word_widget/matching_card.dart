import 'package:flutter/material.dart';

class MatchingCard extends StatelessWidget {
  final String text; // 卡片上的文字 (日文或中文)
  final bool isMatched; // 是否已配對成功
  final bool isSelected; // 是否被選中
  final VoidCallback onTap; // 點擊事件

  const MatchingCard({
    super.key,
    required this.text,
    required this.isMatched,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isMatched) {
      // 如果已配對成功，隱藏卡片
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
