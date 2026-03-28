import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/local/database/character_queries.dart';
import 'package:pride_sys_test_flutter/data/models/character_m.dart';
import 'package:pride_sys_test_flutter/data/remote/repositories/api_character_repo.dart';
import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';
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
  Future<Result<CharacterPageEntity>> getCharacters({required int page}) async {
    try {
      final ApiResponse response = await _api.fetchCharacters(page: page);
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
        await _appDatabase.upsertPageMeta(page: page, hasMore: hasMore);
        final merged = await _mergeOverrides(characters);
        return Success<CharacterPageEntity>(
          data: CharacterPageEntity(characters: merged, hasMore: hasMore),
        );
      }

      return _pageFromCache(
        page,
        fallbackMessage: response.message ?? 'Could not load characters',
      );
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
      return _pageFromCache(
        page,
        fallbackMessage: 'Offline or network error — showing cached data.',
      );
    }
  }

  Future<Result<CharacterPageEntity>> _pageFromCache(
    int page, {
    required String fallbackMessage,
  }) async {
    final cached = await _appDatabase.getCharacters(pageNumber: page);
    if (cached.isEmpty) {
      logger.e(cached.isEmpty);
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
      name: _pick('name', row) ?? base.name,
      status: _pick('status', row) ?? base.status,
      species: _pick('species', row) ?? base.species,
      type: _pick('type', row) ?? base.type,
      gender: _pick('gender', row) ?? base.gender,
      image: base.image,
      url: base.url,
      created: base.created,
      episodes: base.episodes,
      pageNumber: base.pageNumber,
      originEntity: OriginModel(
        name: _pick('origin', row) ?? base.originEntity?.name,
        url: base.originEntity?.url,
      ),
      locationEntity: LocationModel(
        name: _pick('location', row) ?? base.locationEntity?.name,
        url: base.locationEntity?.url,
      ),
    );
  }

  String? _pick(String column, Map<String, dynamic> row) {
    final String? value = row[column];
    return value;
  }
}
