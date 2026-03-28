/// Application text style configuration.
///
/// This class provides a comprehensive text theme with responsive font sizing
/// using ScreenUtil. It defines all text styles used throughout the application,
/// including display, headline, title, body, and label styles.
///
/// All font sizes are responsive and scale based on screen size.
///
/// Example:
/// ```dart
/// Text(
///   'Hello',
///   style: Theme.of(context).textTheme.headlineSmall,
/// )
/// ```
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {

  static TextTheme getTextStyles([Color textColor = Colors.black]) {
    return TextTheme(
      displayLarge: getBaseTextTheme(textColor).copyWith(
        fontSize: 96.sp,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
        color: textColor,
      ),
      displayMedium: getBaseTextTheme(textColor).copyWith(
        fontSize: 60.sp,
        fontWeight: FontWeight.w300,
        color: textColor,
        letterSpacing: 0,
      ),
      displaySmall: getBaseTextTheme(textColor).copyWith(
        fontSize: 48.sp,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineLarge: getBaseTextTheme(textColor).copyWith(
        fontSize: 34.sp,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineMedium: getBaseTextTheme(textColor).copyWith(
        fontSize: 34.sp,
        fontWeight: FontWeight.w400,
        color: textColor,
        letterSpacing: 0,
      ),
      headlineSmall: getBaseTextTheme(textColor).copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
        color: textColor,
      ),
      titleLarge: getBaseTextTheme(textColor).copyWith(
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        color: textColor,
      ),
      titleMedium: getBaseTextTheme(textColor).copyWith(
        fontSize: 16.sp,
        letterSpacing: 0.4,
        color: textColor,
      ),
      titleSmall: getBaseTextTheme(textColor).copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),
      bodyLarge: getBaseTextTheme(textColor).copyWith(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.0,
        color: textColor,
      ),
      bodyMedium: getBaseTextTheme(textColor),
      bodySmall: getBaseTextTheme(textColor).copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelLarge: getBaseTextTheme(textColor).copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textColor,
      ),
      labelMedium: getBaseTextTheme(textColor).copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
      labelSmall: getBaseTextTheme(textColor).copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: textColor,
      ),
    );
  }

  /// Returns the base text style used as a foundation for other styles.
  ///
  /// [color] - Text color for the base style.
  /// Returns a [TextStyle] with default font settings.
  static TextStyle getBaseTextTheme(Color? color) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: 0.1,
    );
  }
}
