import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/routing/app_pages.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/views/character_details_v.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/views/edit_character_details_v.dart';
import 'package:pride_sys_test_flutter/presentation/dashboard/views/dashboard_v.dart';
import 'package:pride_sys_test_flutter/presentation/splash/views/splash_v.dart';

class AppRoutes {
  static List<GetPage> routes = [
    GetPage(name: AppPages.initial, page: () => SplashView()),
    GetPage(name: AppPages.dashboard, page: () => DashboardView()),
    GetPage(
      name: AppPages.characterDetails,
      page: () => CharacterDetailsView(),
    ),
    GetPage(
      name: AppPages.editCharacterDetails,
      page: () => EditCharacterDetailsView(),
    ),
  ];
}
