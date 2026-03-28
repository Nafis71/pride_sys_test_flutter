import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

abstract class FavouriteRepository {
  Future<void> addCharacterToFavourite({required int id});
  Future<void> removeCharacterToFavourite({required int id});
  Future<bool> isFavourite({required int id});

  /// Characters that are both favourited and present in local cache, with edits merged.
  Future<List<CharacterEntity>> getFavouriteCharacters();
}