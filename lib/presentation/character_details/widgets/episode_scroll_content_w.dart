import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

import '../../../common/assets/svgs/svg_asset.dart';
import '../../../common/colors/app_colors.dart';
import '../../../common/utils/dimensions/app_padding.dart';
import '../../common/svg_picture_w.dart';

class EpisodeScrollContent extends StatelessWidget {
  final CharacterEntity? character;

  const EpisodeScrollContent({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: REdgeInsets.symmetric(horizontal: AppPaddings.kDefaultPadding),
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
            decoration: BoxDecoration(
              color: AppColors.cFAFAFA,
              borderRadius: .circular(16.r),
            ),
            child: Column(
              spacing: 8.h,
              children: [
                SvgPictureWidget(assetPath: SvgAsset.movie),
                Text(
                  "Watch Episode ${index + 1}",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ],
            ),
          );
        },
        itemCount: character?.episodes?.length ?? 0,
      ),
    );
  }
}
