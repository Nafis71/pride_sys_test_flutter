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
        batch.insert(characterTable, {
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
          'episode': jsonEncode(character.episodes),
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
      await batch.commit(noResult: true);
      logger.i('Cached ${characters.length} characters');
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  /// Loads cached characters for [ids], preserving the order of [ids].
  Future<List<CharacterModel>> getCharactersByIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    try {
      final Database? database = this.database;
      if (database == null) return [];
      final String placeholders = List.filled(ids.length, '?').join(',');
      final List<Map<String, dynamic>> rows = await database.rawQuery(
        'SELECT * FROM $characterTable WHERE id IN ($placeholders)',
        ids,
      );
      final Map<int, CharacterModel> byId = {};
      for (final Map<String, dynamic> row in rows) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(row);
        final int? id = map['id'] as int?;
        if (id == null) continue;
        final int page = map['page'] as int? ?? 1;
        byId[id] = CharacterModel.fromJson(map, page);
      }
      return ids.map((id) => byId[id]).whereType<CharacterModel>().toList();
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }

  Future<List<CharacterModel>> getCharacters({required int pageNumber}) async {
    try {
      final Database? database = this.database;
      if (database == null) return [];
      final List<Map<String, dynamic>> result = await database.query(
        characterTable,
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
    await database.insert(characterPageMetadata, {
      'page': page,
      'has_more': hasMore ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool?> getPageMetaHasMore(int page) async {
    final Database? database = this.database;
    if (database == null) return null;
    final rows = await database.query(
      characterPageMetadata,
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
    final List<Map<String, dynamic>> rows = await database.query(
      editedCharacterTable,
      where: 'id IN ($placeholders)',
      whereArgs: ids.toList(),
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

  Future<void> upsertEditedCharacter({
    required int id,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required String originName,
    required String locationName,
  }) async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      await database.insert(
        editedCharacterTable,
        <String, Object?>{
          'id': id,
          'name': name,
          'status': status,
          'species': species,
          'type': type,
          'gender': gender,
          'origin': originName,
          'location': locationName,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      logger.i('Saved local edits for character $id');
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<void> deleteAllEditedCharacters() async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      await database.delete(editedCharacterTable);
      logger.i('Cleared all edited_characters rows');
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }
}
