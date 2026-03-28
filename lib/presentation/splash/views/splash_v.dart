import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/assets/svgs/png_asset.dart';
import 'package:pride_sys_test_flutter/common/helpers/post_frame.dart';
import 'package:pride_sys_test_flutter/common/utils/routing/app_pages.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    PostFrame.executeTask(
      task: () {
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (timer.tick == 3) {
            Get.offNamed(AppPages.dashboard);
            timer.cancel();
          }
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(PngAsset.logo),
      ),
    );
  }
}
