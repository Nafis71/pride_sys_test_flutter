/// Bottom navigation bar theme styles for light and dark modes.
///
/// This class provides consistent bottom navigation bar styling across
/// the application. It defines colors, text styles, and visual properties
/// for the navigation bar.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../colors/app_colors.dart';

class BottomNavigationBarStyle {
  static BottomNavigationBarThemeData getLightStyle() => BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      color: AppColors.black,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 12.sp,
    ),
    elevation: 12,
    selectedItemColor: AppColors.black,
    unselectedItemColor: Colors.grey.shade600,
    enableFeedback: false,
  );
}