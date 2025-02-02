import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:learn_flutter/data/models/genre_model.dart';

class DatabaseHelper {
  static Database? _db;
  static const String tableName = 'genres';

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'genres_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            slug TEXT NOT NULL,
            description TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            deleted_at TEXT,
            anime_count INTEGER NOT NULL,
            is_synced INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // CRUD Operations
  Future<int> insertGenre(GenreModel genre) async {
    final db = await database;
    return await db.insert(
      tableName,
      {
        'name': genre.name,
        'slug': genre.slug,
        'description': genre.description,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
        'anime_count': genre.animeCount,
        'is_synced': 0, // 0 = needs sync, 1 = synced
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<GenreModel>> getGenres() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return GenreModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        slug: maps[i]['slug'],
        description: maps[i]['description'],
        createdAt: maps[i]['created_at'],
        updatedAt: maps[i]['updated_at'],
        deletedAt: maps[i]['deleted_at'],
        animeCount: maps[i]['anime_count'],
      );
    });
  }

  Future<int> updateGenre(GenreModel genre) async {
    final db = await database;
    return await db.update(
      tableName,
      {
        'name': genre.name,
        'description': genre.description,
        'updated_at': DateTime.now().toIso8601String(),
        'is_synced': 0,
      },
      where: 'id = ?',
      whereArgs: [genre.id],
    );
  }

  Future<int> deleteGenre(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<GenreModel>> getUnsyncedGenres() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return List.generate(maps.length, (i) {
      return GenreModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        slug: maps[i]['slug'],
        description: maps[i]['description'],
        createdAt: maps[i]['created_at'],
        updatedAt: maps[i]['updated_at'],
        deletedAt: maps[i]['deleted_at'],
        animeCount: maps[i]['anime_count'],
      );
    });
  }

  Future<void> markAsSynced(int id) async {
    final db = await database;
    await db.update(
      tableName,
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearTable() async {
    final db = await database;
    await db.delete(tableName);
  }
}
