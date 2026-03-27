import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/data/remote/controller/network_c.dart';
import 'package:pride_sys_test_flutter/data/remote/requests/api_character_request.dart';
import 'package:pride_sys_test_flutter/domain/uc/character_uc.dart';
import 'package:pride_sys_test_flutter/presentation/dashboard/view_models/dashboard_vm.dart';

import '../../../presentation/home/view_models/home_vm.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<DashboardVM>(() => DashboardVM(), fenix: true);
    Get.lazyPut<HomeVM>(
      () => HomeVM(CharacterUseCase(ApiCharacterRequest(NetworkController()))),
      fenix: true,
    );
  }
}
