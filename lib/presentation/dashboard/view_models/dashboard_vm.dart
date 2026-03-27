import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/assets/svgs/svg_asset.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/views/favourites_v.dart';
import 'package:pride_sys_test_flutter/presentation/home/views/home_v.dart';

class DashboardVM extends GetxController{
  RxInt currentIndex = RxInt(0);

  List<String> dashboardItems = [
    "Home",
    "Favourites",
  ];

  List<String> dashboardOutlinedIcons = [
    SvgAsset.homeOutlined,
    SvgAsset.favouritesOutlined,
  ];

  List<String> dashboardFilledIcons = [
    SvgAsset.homeFilled,
    SvgAsset.favouritesFilled,
  ];

  RxList<Widget> screens = [
    HomeView(),
    FavouritesView(),
  ].obs;
}