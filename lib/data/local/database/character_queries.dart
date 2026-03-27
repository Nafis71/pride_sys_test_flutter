import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/models/character_m.dart';
import 'package:pride_sys_test_flutter/data/models/location_m.dart';
import 'package:pride_sys_test_flutter/data/models/origin_m.dart';
import 'package:sqflite/sqflite.dart';

extension CharacterQueries on AppDatabase {
  Future<void> insertCharacters({
    required List<CharacterModel> characters,
  }) async {
    try {
      final Database? database = this.database;
      if (database == null) return;
      final Batch batch = database.batch();
      for (CharacterModel character in characters) {
        batch.insert('characters', {
          'id': character.id ?? 0,
          'name': character.name ?? "",
          'status': character.status ?? "",
          'species': character.species ?? "",
          'type': character.type ?? "",
          'gender': character.gender ?? "",
          'origin': (character.originEntity as OriginModel).toJson(),
          'location': (character.locationEntity as LocationModel).toJson(),
          'image': character.image ?? "",
          'page': character.pageNumber,
        }, conflictAlgorithm: .replace);
      }
      await batch.commit(noResult: true);
      logger.i("Inserted into characters");
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<List<CharacterModel>> getCharacters({required int pageNumber}) async {
    try {
      final Database? database = this.database;
      if (database == null) return [];
      List<Map<String, dynamic>> result = await database.query(
        "characters",
        where: 'page = ?',
        whereArgs: [pageNumber],
      );
      List<CharacterModel> characters = [];
      for (Map<String, dynamic> character in result) {
        characters.add(CharacterModel.fromJson(character, pageNumber));
      }
      return characters;
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }
}
