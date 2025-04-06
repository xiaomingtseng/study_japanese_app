class Word {
  final String japanese; // 日文單詞（片假名或平假名）
  final String chinese; // 中文意思
  final String? romaji; // 羅馬拼音（可選）
  final String? example; // 例句（可選）
  final int? jlpt;

  bool isLearned = false; // 是否已學習過

  Word({
    required this.japanese,
    required this.chinese,
    this.romaji,
    this.example,
    this.jlpt,
  });

  void toggleLearned() {
    isLearned = !isLearned;
  }

  @override
  String toString() {
    return 'Word(japanese: $japanese, chinese: $chinese, romaji: $romaji, example: $example)';
  }
}
