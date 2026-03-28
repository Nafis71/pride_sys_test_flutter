import 'dart:convert';

import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/models/character_m.dart';
import 'package:sqflite/sqflite.dart';

extension CharacterQueries on AppDatabase {
  Future<void> insertCharacters({
    required List<CharacterModel> characters,
  }) async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      final Batch batch = database.batch();
      for (final CharacterModel character in characters) {
        batch.insert('characters', {
          'id': character.id ?? 0,
          'name': character.name ?? '',
          'status': character.status ?? '',
          'species': character.species ?? '',
          'type': character.type ?? '',
          'gender': character.gender ?? '',
          'origin': jsonEncode({
            'name': character.originEntity?.name,
            'url': character.originEntity?.url,
          }),
          'location': jsonEncode({
            'name': character.locationEntity?.name,
            'url': character.locationEntity?.url,
          }),
          'image': character.image ?? '',
          'page': character.pageNumber,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit(noResult: true);
      logger.i('Cached ${characters.length} characters');
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<List<CharacterModel>> getCharacters({required int pageNumber}) async {
    try {
      final Database? database = this.database;
      if (database == null) return [];
      final List<Map<String, dynamic>> result = await database.query(
        'characters',
        where: 'page = ?',
        whereArgs: [pageNumber],
        orderBy: 'id ASC',
      );
      final List<CharacterModel> characters = [];
      for (final Map<String, dynamic> row in result) {
        characters.add(
          CharacterModel.fromJson(Map<String, dynamic>.from(row), pageNumber),
        );
      }
      return characters;
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }

  Future<void> upsertPageMeta({
    required int page,
    required bool hasMore,
  }) async {
    final Database? database = this.database;
    if (database == null) return;
    await database.insert('character_page_meta', {
      'page': page,
      'has_more': hasMore ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool?> getPageMetaHasMore(int page) async {
    final Database? database = this.database;
    if (database == null) return null;
    final rows = await database.query(
      'character_page_meta',
      where: 'page = ?',
      whereArgs: [page],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final hasMore = rows.first['has_more'];
    if (hasMore is int) return hasMore != 0;
    return null;
  }

  Future<Map<int, Map<String, dynamic>>> getCharacterOverrides(
    Set<int> ids,
  ) async {
    final Database? database = this.database;
    if (database == null || ids.isEmpty) return {};
    final String placeholders = List.filled(ids.length, '?').join(',');
    final List<Map<String, dynamic>> rows = await database.rawQuery(
      'SELECT * FROM edited_characters WHERE id IN ($placeholders)',
      ids.toList(),
    );
    final result = <int, Map<String, dynamic>>{};
    for (final row in rows) {
      final id = row['id'];
      if (id is int) {
        result[id] = Map<String, dynamic>.from(row);
      }
    }
    return result;
  }
}
