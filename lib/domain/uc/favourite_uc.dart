import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/local/database/favourite_queries.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/repositories/favourite_repo.dart';

class FavouriteUseCase implements FavouriteRepository {
  FavouriteUseCase({
    required AppDatabase db,
    required CharacterRepository characterRepository,
  })  : _appDatabase = db,
        _characterRepository = characterRepository;

  final AppDatabase _appDatabase;
  final CharacterRepository _characterRepository;

  @override
  Future<void> addCharacterToFavourite({required int id}) async {
    try {
      await _appDatabase.addFavourites(id: id);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  @override
  Future<bool> isFavourite({required int id}) async {
    try {
      return await _appDatabase.isFavourite(id: id);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return false;
  }

  @override
  Future<void> removeCharacterToFavourite({required int id}) async {
    try {
      await _appDatabase.removeFavourites(id: id);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  @override
  Future<List<CharacterEntity>> getFavouriteCharacters() async {
    try {
      await _appDatabase.initDB();
      final List<int> ids = await _appDatabase.getFavoriteIds();
      if (ids.isEmpty) return [];
      return await _characterRepository.getCharactersByIds(ids);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return [];
  }
}
