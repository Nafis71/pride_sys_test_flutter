import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';

class CharactersHomeHeader extends StatelessWidget {
  const CharactersHomeHeader({super.key, this.onInfoTap});

  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 8.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Characters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.04),
              shape: .circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              onPressed: onInfoTap,
              icon: Icon(
                Icons.info_outline,
                color: AppColors.black.withValues(alpha: 0.9),
                size: 26.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
