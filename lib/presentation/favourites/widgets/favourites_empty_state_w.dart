import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';

class FavouritesEmptyStateW extends StatelessWidget {
  const FavouritesEmptyStateW({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 64.sp,
              color: AppColors.black.withValues(alpha: 0.25),
            ),
            SizedBox(height: 16.h),
            Text(
              'No favourites yet',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.c1F222A,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add characters from the home grid or detail screen. They stay available offline once cached.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.black.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
