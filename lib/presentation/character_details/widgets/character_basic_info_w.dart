import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

import '../../../common/colors/app_colors.dart';
import '../../../common/utils/dimensions/spacing.dart';

class CharacterBasicInfo extends StatelessWidget {
  final CharacterEntity? character;

  const CharacterBasicInfo({super.key, this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          character?.name ?? "",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacing.vertical(2),
        Row(
          mainAxisAlignment: .center,
          spacing: 8.w,
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: (character?.status?.toLowerCase() == "alive")
                    ? AppColors.green
                    : AppColors.red,
                shape: .circle,
              ),
            ),
            Text(
              character?.status ?? "",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: (character?.status?.toLowerCase() == "alive")
                    ? AppColors.green
                    : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
