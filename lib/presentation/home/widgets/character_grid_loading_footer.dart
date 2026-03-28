import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Full-width loader shown below the grid while the next page loads.
class CharacterGridLoadingFooter extends StatelessWidget {
  const CharacterGridLoadingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 24.h),
      child: Center(
        child: SizedBox(
          width: 28.w,
          height: 28.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Color(0xFFBB86FC),
          ),
        ),
      ),
    );
  }
}
