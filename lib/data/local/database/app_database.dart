import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static AppDatabase? _instance;
  static Database? _database;
  final String characterTable = "characters";
  final String favouriteTable = "favorites";
  final String editedCharacterTable = "edited_characters";
  final String characterPageMetadata = "character_page_meta";

  AppDatabase._internal();

  factory AppDatabase() => _instance ??= AppDatabase._internal();

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
      CREATE TABLE $characterTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        status TEXT,
        species TEXT,
        type TEXT,
        gender TEXT,
        origin TEXT,
        location TEXT,
        image TEXT,
        page INTEGER,
        episode TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE $favouriteTable (
        id INTEGER PRIMARY KEY
      )
    ''');

    await db.execute('''
      CREATE TABLE $editedCharacterTable (
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
      CREATE TABLE IF NOT EXISTS $characterPageMetadata (
        page INTEGER PRIMARY KEY,
        has_more INTEGER NOT NULL
      )
    ''');
  }
}
