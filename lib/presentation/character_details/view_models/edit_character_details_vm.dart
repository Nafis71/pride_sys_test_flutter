import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/view_models/favourites_vm.dart';
import 'package:pride_sys_test_flutter/presentation/home/view_models/home_vm.dart';

class EditCharacterDetailsVM extends GetxController {
  EditCharacterDetailsVM(this._characterRepository);

  final CharacterRepository _characterRepository;

  final RxBool isSaving = false.obs;

  int? _characterId;

  CharacterEntity? bindRouteArguments(dynamic arguments) {
    final Map<String, dynamic>? map =
        arguments is Map<String, dynamic> ? arguments : null;
    final CharacterEntity? character = map?['character'] as CharacterEntity?;
    _characterId = character?.id;
    return character;
  }

  String _trim(String text) => text.trim();

  Future<void> submitFromFormInputs({
    required String nameText,
    required String statusText,
    required String speciesText,
    required String typeText,
    required String genderText,
    required String originNameText,
    required String locationNameText,
  }) async {
    final int? id = _characterId;
    if (id == null) return;
    isSaving.value = true;
    try {
      await _characterRepository.saveLocalCharacterEdits(
        characterId: id,
        name: _trim(nameText),
        status: _trim(statusText),
        species: _trim(speciesText),
        type: _trim(typeText),
        gender: _trim(genderText),
        originName: _trim(originNameText),
        locationName: _trim(locationNameText),
      );
      if (Get.isRegistered<HomeVM>()) {
        await Get.find<HomeVM>().syncCharacterFromRepository(id);
      }
      if (Get.isRegistered<FavouritesVM>()) {
        await Get.find<FavouritesVM>().loadFavourites();
      }
      Get.back();
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    } finally {
      isSaving.value = false;
    }
  }
}
