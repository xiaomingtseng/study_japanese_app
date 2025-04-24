import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final Database instance = Database._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Database._init();

  // 根據 JLPT 分級取得對應的集合
  CollectionReference<Map<String, dynamic>> getCollection(String jlptLevel) {
    // 根據傳入的 jlptLevel 決定集合名稱
    String collectionName;
    switch (jlptLevel) {
      case 'N5':
        collectionName = 'n5_words';
        break;
      case 'N4':
        collectionName = 'n4_words';
        break;
      case 'N3':
        collectionName = 'n3_words';
        break;
      case 'N2':
        collectionName = 'n2_words';
        break;
      case 'N1':
        collectionName = 'n1_words';
        break;
      default:
        throw ArgumentError('Invalid JLPT level: $jlptLevel');
    }
    return _firestore.collection(collectionName);
  }

  // 插入單字
  Future<void> insertWord(String jlptLevel, String word, String meaning) async {
    final collection = getCollection(jlptLevel);
    await collection.add({'word': word, 'meaning': meaning});
  }

  // 刪除單字
  Future<void> deleteWord(String jlptLevel, String wordId) async {
    final collection = getCollection(jlptLevel);
    await collection.doc(wordId).delete();
  }

  // 取得所有單字
  Future<List<Map<String, dynamic>>> fetchWords(String jlptLevel) async {
    final collection = getCollection(jlptLevel);
    final querySnapshot = await collection.get();

    // for (var doc in querySnapshot.docs) {
    //   print('Document ID: ${doc.id}');
    //   print('Document Data: ${doc.data()}');
    // }

    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  // 根據分級和回數篩選單字
  Future<List<Map<String, dynamic>>> fetchWordsByLevelAndRound(
    String jlptLevel,
    int round,
  ) async {
    final collection = getCollection(jlptLevel);

    // 計算單字的起始和結束索引
    final int startIndex = (round - 1) * 20;
    final int endIndex = round * 20;

    // 取得所有單字
    final querySnapshot = await collection.get();
    final allWords =
        querySnapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();

    // 確保區間不超出單字數量
    final selectedWords = allWords.sublist(
      startIndex,
      endIndex > allWords.length ? allWords.length : endIndex,
    );

    return selectedWords;
  }
}
