import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/data/local/database/app_database.dart';
import 'package:pride_sys_test_flutter/data/remote/controller/network_c.dart';
import 'package:pride_sys_test_flutter/data/remote/requests/api_character_request.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/uc/character_uc.dart';
import 'package:pride_sys_test_flutter/domain/uc/favourite_uc.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/view_models/character_details_vm.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/view_models/edit_character_details_vm.dart';
import 'package:pride_sys_test_flutter/presentation/dashboard/view_models/dashboard_vm.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/view_models/favourites_vm.dart';

import '../../../presentation/home/view_models/home_vm.dart';

class DependencyInjection {
  static void init() {
    final AppDatabase db = AppDatabase();

    Get.lazyPut<CharacterRepository>(
      () => CharacterUseCase(
        api: ApiCharacterRequest(NetworkController()),
        database: db,
      ),
      fenix: true,
    );

    Get.lazyPut<DashboardVM>(() => DashboardVM(), fenix: true);
    Get.lazyPut<HomeVM>(
      () => HomeVM(Get.find<CharacterRepository>()),
      fenix: true,
    );
    Get.lazyPut<FavouritesVM>(
      () => FavouritesVM(
        FavouriteUseCase(
          db: db,
          characterRepository: Get.find<CharacterRepository>(),
        ),
      ),
      fenix: true,
    );
    Get.lazyPut<CharacterDetailsVM>(
      () => CharacterDetailsVM(
        FavouriteUseCase(
          db: db,
          characterRepository: Get.find<CharacterRepository>(),
        ),
        Get.find<CharacterRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut<EditCharacterDetailsVM>(
      () => EditCharacterDetailsVM(Get.find<CharacterRepository>()),
      fenix: true,
    );
  }
}
