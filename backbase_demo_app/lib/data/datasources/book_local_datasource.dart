import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/book_entity.dart';

class BookLocalDataSource {
  static final BookLocalDataSource _instance = BookLocalDataSource._internal();

  factory BookLocalDataSource() => _instance;

  BookLocalDataSource._internal();

  Database? _database;

  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), 'books.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE books(
          key TEXT PRIMARY KEY,
          title TEXT,
          author TEXT,
          coverUrl TEXT
        )
      ''');
    });
  }

  Future<List<BookEntity>> getAllBooks() async {
    final database = await db;
    final result = await database.query('books');
    return result.map((json) => BookEntity.fromMap(json)).toList();
  }


  Future<void> saveBook(BookEntity book) async {
    final database = await db;
    await database.insert(
      'books',
      {
        'key': book.key,
        'title': book.title,
        'author': book.author,
        'coverUrl': book.coverUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
