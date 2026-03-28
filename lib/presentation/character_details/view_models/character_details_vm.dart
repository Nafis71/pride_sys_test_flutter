import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/repositories/favourite_repo.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/view_models/favourites_vm.dart';

class CharacterDetailsVM extends GetxController {
  CharacterDetailsVM(
    this._favouriteRepository,
    this._characterRepository,
  );

  final FavouriteRepository _favouriteRepository;
  final CharacterRepository _characterRepository;

  final Rxn<CharacterEntity> character = Rxn<CharacterEntity>();

  RxBool isSelectedCharacterIsFavourite = false.obs;

  void bindCharacter(CharacterEntity? entity) {
    character.value = entity;
  }

  Future<void> refreshCharacter() async {
    final int? id = character.value?.id;
    if (id == null) return;
    try {
      final List<CharacterEntity> list =
          await _characterRepository.getCharactersByIds([id]);
      if (list.isNotEmpty) {
        character.value = list.first;
      }
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<void> isFavourite({required int? id}) async {
    try {
      isSelectedCharacterIsFavourite.value = id == null
          ? false
          : await _favouriteRepository.isFavourite(id: id);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }

  Future<void> toggleFavourites(int? id) async {
    try {
      if (id == null) return;
      if (isSelectedCharacterIsFavourite.value) {
        await _favouriteRepository.removeCharacterToFavourite(id: id);
      } else {
        await _favouriteRepository.addCharacterToFavourite(id: id);
      }
      isSelectedCharacterIsFavourite.value =
          !isSelectedCharacterIsFavourite.value;
      if (Get.isRegistered<FavouritesVM>()) {
        Get.find<FavouritesVM>().loadFavourites();
      }
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
  }
}
