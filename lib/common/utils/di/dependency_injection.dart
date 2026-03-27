import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/presentation/dashboard/view_models/dashboard_vm.dart';

class DependencyInjection {
  static void init() {
    Get.lazyPut<DashboardVM>(() => DashboardVM(), fenix: true);
  }
}
