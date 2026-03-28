import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/favourite_repo.dart';

class FavouritesVM extends GetxController {
  FavouritesVM(this._favouriteRepository);

  final FavouriteRepository _favouriteRepository;

  final RxList<CharacterEntity> favourites = RxList<CharacterEntity>();
  final RxBool isLoading = false.obs;

  Future<void> loadFavourites() async {
    isLoading.value = true;
    try {
      final List<CharacterEntity> list =
          await _favouriteRepository.getFavouriteCharacters();
      favourites.assignAll(list);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }
}
