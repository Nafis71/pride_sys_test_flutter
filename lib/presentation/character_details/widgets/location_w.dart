import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

import '../../../common/assets/svgs/svg_asset.dart';
import '../../../common/colors/app_colors.dart';
import '../../../common/utils/dimensions/app_padding.dart';
import '../../../common/utils/dimensions/spacing.dart';
import '../../common/svg_picture_w.dart';

class Location extends StatelessWidget {
  final CharacterEntity? character;
  const Location({super.key, this.character});

  @override
  Widget build(BuildContext context) {
    return                   Align(
      alignment: .centerLeft,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "Last Known Location",
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Spacing.vertical(8),
          Container(
            padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
            decoration: BoxDecoration(
              color: AppColors.cFAFAFA,
              borderRadius: .circular(16.r),
            ),
            child: Row(
              spacing: 8.w,
              children: [
                SvgPictureWidget(
                  assetPath: SvgAsset.planet,
                  width: 26.r,
                  height: 26.h,
                ),
                Expanded(
                  child: Text(
                    character?.locationEntity?.name ?? "",
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 22.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
