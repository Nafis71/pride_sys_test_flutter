import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_page_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/result/failure.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';
import 'package:pride_sys_test_flutter/domain/result/success.dart';
import 'package:pride_sys_test_flutter/presentation/common/common_toast.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/view_models/favourites_vm.dart';

class HomeVM extends GetxController {
  RxList<CharacterEntity> characters = RxList();
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;
  /// Filters [characters] by name (case-insensitive) when non-empty after trim.
  final RxString searchQuery = ''.obs;
  int _currentPage = 1;
  final CharacterRepository _characterRepository;

  HomeVM(this._characterRepository);

  /// Subset of [characters] visible in the grid for the current [searchQuery].
  List<CharacterEntity> get charactersForDisplay {
    final String q = searchQuery.value.trim().toLowerCase();
    final List<CharacterEntity> all = List<CharacterEntity>.from(characters);
    if (q.isEmpty) return all;
    return all
        .where(
          (CharacterEntity c) =>
              (c.name ?? '').toLowerCase().contains(q),
        )
        .toList();
  }

  void applySearchQuery(String raw) {
    searchQuery.value = raw;
  }

  /// Updates one row in the in-memory list after local edits (matches SQLite cache).
  Future<void> syncCharacterFromRepository(int id) async {
    try {
      final List<CharacterEntity> list = await _characterRepository
          .getCharactersByIds([id]);
      if (list.isEmpty) return;
      final CharacterEntity updated = list.first;
      final int index = characters.indexWhere(
        (CharacterEntity c) => c.id == id,
      );
      if (index < 0) return;

      final List<CharacterEntity> next = List<CharacterEntity>.from(characters);
      next[index] = updated;
      characters.assignAll(next);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  /// Clears every row in [edited_characters] and refreshes the current grid + favourites list.
  Future<void> restoreAllLocalEdits() async {
    try {
      await _characterRepository.clearAllLocalCharacterEdits();
      final List<int> ids = characters
          .map((CharacterEntity character) => character.id)
          .whereType<int>()
          .toList();
      if (ids.isEmpty && Get.isRegistered<FavouritesVM>()) {
        await Get.find<FavouritesVM>().loadFavourites();
        return;
      }
      final List<CharacterEntity> refreshed = await _characterRepository
          .getCharactersByIds(ids);
      final Map<int, CharacterEntity> byId = <int, CharacterEntity>{
        for (final CharacterEntity character in refreshed)
          if (character.id != null) character.id!: character,
      };
      final List<CharacterEntity> next = characters
          .map(
            (CharacterEntity character) => character.id != null
            ? (byId[character.id!] ?? character)
            : character,
      )
          .toList();
      characters.assignAll(next);
      if (Get.isRegistered<FavouritesVM>()) {
        await Get.find<FavouritesVM>().loadFavourites();
      }
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }
  Future<void> loadCharacters({bool loadMore = false}) async {
    if (isLoading.value || isLoadingMore.value) return;
    if (loadMore && !hasMore.value) return;

    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        _currentPage = 1;
        characters.clear();
        hasMore.value = true;
      }
      final Result<CharacterPageEntity> result = await _characterRepository
          .getCharacters(page: _currentPage);
      switch (result) {
        case Failure<CharacterPageEntity>(:final failureMessage):
          CommonToast.show(
            context: Get.context,
            title: failureMessage?.toString() ?? 'Request failed',
          );
          return;
        case Success<CharacterPageEntity>(:final data):
          final page = data;
          if (page == null) return;
          if (loadMore) {
            characters.addAll(page.characters);
          } else {
            characters.assignAll(page.characters);
          }
          hasMore.value = page.hasMore;
          _currentPage++;
          logger.i(
            'Character list length : ${characters.length}, fetched page: ${_currentPage - 1}, hasMore: ${page.hasMore}',
          );
      }
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
