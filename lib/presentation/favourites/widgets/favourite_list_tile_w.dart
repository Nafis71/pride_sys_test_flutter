import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/common/network_image_loader_w.dart';

class FavouriteListTileW extends StatelessWidget {
  const FavouriteListTileW({
    super.key,
    required this.character,
    this.onTap,
  });

  final CharacterEntity character;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String status = character.status ?? '';
    final Color statusColor = status.toLowerCase() == 'alive'
        ? AppColors.green
        : AppColors.red;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: NetworkImageLoader(url: character.image),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.c1F222A,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Species: ${character.species ?? '—'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.black.withValues(alpha: 0.65),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.black.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
