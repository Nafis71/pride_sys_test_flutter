/// Application theme configuration.
///
/// This class provides theme data for both light and dark modes.
/// It combines various style components (text, cards, app bars, etc.)
/// into cohesive theme configurations that can be applied to the app.
///
/// The themes use Material 3 design system and include:
/// - Text styles with responsive sizing
/// - Card styles for light/dark modes
/// - App bar styles
/// - Bottom navigation bar styles
/// - Color schemes
///
/// Example:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.getLightTheme(),
///   darkTheme: AppTheme.getDarkTheme(),
/// )
/// ```
import 'package:flutter/material.dart';
import 'package:pride_sys_test_flutter/common/themes/text_style/text_style.dart';

import '../colors/app_colors.dart';
import 'bottom_navigation_bar_style/bottom_navigation_bar_style.dart';

class AppTheme {
  /// Returns the light theme configuration.
  ///
  /// Creates a complete [ThemeData] object with:
  /// - Material 3 design system
  /// - White scaffold background
  /// - Blue color scheme
  /// - Custom text styles
  /// - Card styles
  /// - App bar styles
  /// - Bottom navigation bar styles
  ///
  /// Returns:
  /// - [ThemeData] configured for light mode
  static ThemeData getLightTheme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      onSurface: Colors.black,
    ),
    brightness: Brightness.light,
    textTheme: AppTextStyle.getTextStyles(),
    bottomNavigationBarTheme: BottomNavigationBarStyle.getLightStyle(),
    splashColor: AppColors.cTransparent,
    splashFactory: NoSplash.splashFactory,
  );

  static ThemeData getDarkTheme() => getLightTheme();
}
