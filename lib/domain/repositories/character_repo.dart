import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_page_e.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';

abstract class CharacterRepository {
  /// [nameQuery] filters via API `name` when non-empty; omit for full list.
  Future<Result<CharacterPageEntity>> getCharacters({
    required int page,
    String? nameQuery,
  });

  /// Cached characters for [ids] (favourite order preserved), with local edits merged.
  Future<List<CharacterEntity>> getCharactersByIds(List<int> ids);

  /// Persists user edits in [edited_characters]. Values are trimmed; empty string is stored as blank (not API).
  Future<void> saveLocalCharacterEdits({
    required int characterId,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required String originName,
    required String locationName,
  });

  /// Deletes all rows in [edited_characters] so UI shows API/cached data everywhere.
  Future<void> clearAllLocalCharacterEdits();
}