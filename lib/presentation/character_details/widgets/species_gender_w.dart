import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

import '../../../common/colors/app_colors.dart';
import '../../../common/utils/dimensions/app_padding.dart';

class SpeciesGender extends StatelessWidget {
  final CharacterEntity? character;

  const SpeciesGender({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
      decoration: BoxDecoration(
        color: AppColors.cFAFAFA,
        borderRadius: .circular(16.r),
      ),
      child: Column(
        spacing: AppPaddings.kDefaultPadding.h,
        children: [
          _buildRow(context: context, header: "Species", value: character?.species),
          _buildRow(context: context, header: "Gender", value: character?.gender),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    String? header,
    String? value,
  }) {
    return Row(
      spacing: 12.w,
      children: [
        Text(
          header ?? "",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 15.sp,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            textAlign: .end,
            value ?? "",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
