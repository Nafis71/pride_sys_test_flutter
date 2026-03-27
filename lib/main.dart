import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/di/dependency_injection.dart';
import 'package:pride_sys_test_flutter/common/utils/routing/app_routes.dart';
import 'package:pride_sys_test_flutter/data/remote/controller/network_c.dart';

import 'common/utils/routing/app_pages.dart';

void main() {
  _injectDependencies();
  runApp(
    ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      child: PrideSysTestApp(),
    ),
  );
}

void _injectDependencies(){
  NetworkController().init();
  DependencyInjection.init();
}

class PrideSysTestApp extends StatelessWidget {
  const PrideSysTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PrideSys Test App',
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      initialRoute: AppPages.initial,
    );
  }
}
