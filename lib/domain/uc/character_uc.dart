import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/local/database/character_queries.dart';
import 'package:pride_sys_test_flutter/data/models/character_m.dart';
import 'package:pride_sys_test_flutter/data/remote/repositories/api_character_repo.dart';
import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_page_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/result/failure.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';
import 'package:pride_sys_test_flutter/domain/result/success.dart';

import '../../data/models/location_m.dart';
import '../../data/models/origin_m.dart';

/// Fetches from API, writes cache, merges local edits. Offline: serves cache + edits.
class CharacterUseCase implements CharacterRepository {
  CharacterUseCase({
    required ApiCharacterRepository api,
    required AppDatabase database,
  }) : _api = api,
       _appDatabase = database;

  final ApiCharacterRepository _api;
  final AppDatabase _appDatabase;

  static const int _apiPageSize = 20;

  @override
  Future<Result<CharacterPageEntity>> getCharacters({
    required int page,
    String? nameQuery,
  }) async {
    final String? name = switch (nameQuery) {
      final String s when s.trim().isNotEmpty => s.trim(),
      _ => null,
    };

    try {
      final ApiResponse response =
          await _api.fetchCharacters(page: page, name: name);
      if (response.isSuccess && response.data is Map<String, dynamic>) {
        final map = response.data as Map<String, dynamic>;
        final rawResults = map['results'];
        final info = map['info'];
        if (rawResults is! List) {
          return Failure<CharacterPageEntity>(
            failureMessage: 'Invalid response shape',
          );
        }
        final hasMore = info is Map<String, dynamic> && info['next'] != null;
        final characters = rawResults
            .map(
              (e) => CharacterModel.fromJson(
                Map<String, dynamic>.from(e as Map),
                page,
              ),
            )
            .toList();
        await _appDatabase.insertCharacters(characters: characters);
        if (name == null) {
          await _appDatabase.upsertPageMeta(page: page, hasMore: hasMore);
        }
        final merged = await _mergeOverrides(characters);
        return Success<CharacterPageEntity>(
          data: CharacterPageEntity(characters: merged, hasMore: hasMore),
        );
      }

      if (name != null && response.statusCode == 404) {
        return Success<CharacterPageEntity>(
          data: CharacterPageEntity(characters: [], hasMore: false),
        );
      }
      if (name != null) {
        return Failure<CharacterPageEntity>(
          failureMessage: response.message ?? 'Search failed',
        );
      }

      return _pageFromCache(
        page,
        fallbackMessage: response.message ?? 'Could not load characters',
      );
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
      if (name != null) {
        return Failure<CharacterPageEntity>(
          failureMessage:
              'Search needs a network connection. Try again when online.',
        );
      }
      return _pageFromCache(
        page,
        fallbackMessage: 'Offline or network error — showing cached data.',
      );
    }
  }

  @override
  Future<List<CharacterEntity>> getCharactersByIds(List<int> ids) async {
    try {
      if (ids.isEmpty) return [];
      final List<CharacterModel> cached =
          await _appDatabase.getCharactersByIds(ids);
      return _mergeOverrides(cached);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }

  @override
  Future<void> saveLocalCharacterEdits({
    required int characterId,
    required String name,
    required String status,
    required String species,
    required String type,
    required String gender,
    required String originName,
    required String locationName,
  }) async {
    await _appDatabase.initDB();
    await _appDatabase.upsertEditedCharacter(
      id: characterId,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      originName: originName,
      locationName: locationName,
    );
  }

  @override
  Future<void> clearAllLocalCharacterEdits() async {
    await _appDatabase.deleteAllEditedCharacters();
  }

  Future<Result<CharacterPageEntity>> _pageFromCache(
    int page, {
    required String fallbackMessage,
  }) async {
    final cached = await _appDatabase.getCharacters(pageNumber: page);
    if (cached.isEmpty) {
      logger.i(cached.isEmpty);
      return Failure<CharacterPageEntity>(failureMessage: fallbackMessage);
    }
    final hasMore =
        await _appDatabase.getPageMetaHasMore(page) ?? (cached.length >= _apiPageSize);
    final merged = await _mergeOverrides(cached);
    return Success<CharacterPageEntity>(
      data: CharacterPageEntity(characters: merged, hasMore: hasMore),
    );
  }

  Future<List<CharacterModel>> _mergeOverrides(
    List<CharacterModel> list,
  ) async {
    final ids = list.map((character) => character.id).whereType<int>().toSet();
    if (ids.isEmpty) return list;
    final overrides = await _appDatabase.getCharacterOverrides(ids);
    return list.map((character) {
      final id = character.id;
      if (id == null) return character;
      final row = overrides[id];
      if (row == null) return character;
      return _applyOverride(character, row);
    }).toList();
  }

  CharacterModel _applyOverride(CharacterModel base, Map<String, dynamic> row) {
    return CharacterModel(
      id: base.id,
      name: _editedText('name', row, base.name),
      status: _editedText('status', row, base.status),
      species: _editedText('species', row, base.species),
      type: _editedText('type', row, base.type),
      gender: _editedText('gender', row, base.gender),
      image: base.image,
      url: base.url,
      created: base.created,
      episodes: base.episodes,
      pageNumber: base.pageNumber,
      originEntity: OriginModel(
        name: _editedText('origin', row, base.originEntity?.name),
        url: base.originEntity?.url,
      ),
      locationEntity: LocationModel(
        name: _editedText('location', row, base.locationEntity?.name),
        url: base.locationEntity?.url,
      ),
    );
  }

  /// SQL NULL or missing key → use [base]. Empty string is kept (no API fallback).
  String? _editedText(
    String column,
    Map<String, dynamic> row,
    String? base,
  ) {
    if (!row.containsKey(column)) return base;
    final dynamic value = row[column];
    if (value == null) return base;
    return value.toString();
  }
}
