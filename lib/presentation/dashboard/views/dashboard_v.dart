import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/presentation/dashboard/view_models/dashboard_vm.dart';

import '../../common/svg_picture_w.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final DashboardVM _dashboardVM = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        body: _dashboardVM.screens[_dashboardVM.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _dashboardVM.currentIndex.value,
          useLegacyColorScheme: false,
          onTap: (index) {
            _dashboardVM.currentIndex.value = index;
          },
          items: List.generate(_dashboardVM.screens.length, (index) {
            return _getNavigationBarItem(index);
          }),
        ),
      ),
    );
  }

  BottomNavigationBarItem _getNavigationBarItem(int index) {
    return BottomNavigationBarItem(
      icon: RPadding(
        padding: .only(top: 8.r,bottom: 3.r),
        child: SvgPictureWidget(
          assetPath: _dashboardVM.dashboardOutlinedIcons[index],
          width: 24.w,
          height: 24.h,
          color: _dashboardVM.currentIndex.value == index
              ? Colors.black
              : Colors.grey.shade600,
        ),
      ),
      label: _dashboardVM.dashboardItems[index],
      activeIcon: RPadding(
        padding: .only(top: 8.r,bottom: 3.r),
        child: SvgPictureWidget(
          width: 24.w,
          height: 24.h,
          assetPath: _dashboardVM.dashboardFilledIcons[index],
        ),
      ),
    );
  }

}
