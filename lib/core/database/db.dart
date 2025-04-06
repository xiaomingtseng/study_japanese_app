import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('japanese_words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertWord(String word, String meaning) async {
    final db = await instance.database;
    return await db.insert('words', {'word': word, 'meaning': meaning});
  }

  Future<int> deleteWord(String word) async {
    final db = await instance.database;
    return await db.delete('words', where: 'word = ?', whereArgs: [word]);
  }

  Future<List<Map<String, dynamic>>> fetchWords() async {
    final db = await instance.database;
    return await db.query('words');
  }
}
