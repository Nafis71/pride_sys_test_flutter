import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase? _instance;
  static Database? _database;

  AppDatabase._internal();

  factory AppDatabase()=> _instance ??= AppDatabase._internal();

  Database? get database => _database;

  Future<void> initDB() async {
    if (_database != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "app_db.db");
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await _createCharacterTables(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createPageMetaTable(db);
    }
  }

  Future<void> _createCharacterTables(Database db) async {
    await db.execute('''
      CREATE TABLE characters (
        id INTEGER PRIMARY KEY,
        name TEXT,
        status TEXT,
        species TEXT,
        type TEXT,
        gender TEXT,
        origin TEXT,
        location TEXT,
        image TEXT,
        page INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE edited_characters (
        id INTEGER PRIMARY KEY,
        name TEXT,
        status TEXT,
        species TEXT,
        type TEXT,
        gender TEXT,
        origin TEXT,
        location TEXT
      )
    ''');
    await _createPageMetaTable(db);
  }

  /// Stores API [info.next] per page so pagination works offline.
  Future<void> _createPageMetaTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS character_page_meta (
        page INTEGER PRIMARY KEY,
        has_more INTEGER NOT NULL
      )
    ''');
  }
}