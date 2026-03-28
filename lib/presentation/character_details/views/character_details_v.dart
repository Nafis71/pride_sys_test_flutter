import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/assets/svgs/svg_asset.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/spacing.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/common/network_image_loader_w.dart';
import 'package:pride_sys_test_flutter/presentation/common/svg_picture_w.dart';

import '../../../common/colors/app_colors.dart';

class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({super.key});

  @override
  State<CharacterDetailsView> createState() => _CharacterDetailsViewState();
}

class _CharacterDetailsViewState extends State<CharacterDetailsView> {
  late final Map<String, dynamic>? _arguments;
  late final CharacterEntity? _character;

  @override
  void initState() {
    _arguments = Get.arguments;
    _character = _arguments?['character'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _character?.name ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          RPadding(
            padding: REdgeInsets.symmetric(
              horizontal: AppPaddings.kDefaultPadding,
            ),
            child: Icon(
              Icons.favorite_outline_rounded,
              size: 26.r,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: NetworkImageLoader(url: _character?.image)),
          SliverToBoxAdapter(
            child: RPadding(
              padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
              child: Column(
                children: [
                  Text(
                    _character?.name ?? "",
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
                          color: (_character?.status?.toLowerCase() == "alive")
                              ? AppColors.green
                              : AppColors.red,
                          shape: .circle,
                        ),
                      ),
                      Text(
                        _character?.status ?? "",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: (_character?.status?.toLowerCase() == "alive")
                              ? AppColors.green
                              : AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  Spacing.vertical(12),
                  Container(
                    padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
                    decoration: BoxDecoration(
                      color: AppColors.cFAFAFA,
                      borderRadius: .circular(16.r),
                    ),
                    child: Column(
                      spacing: AppPaddings.kDefaultPadding.h,
                      children: [
                        Row(
                          spacing: 12.w,
                          children: [
                            Text(
                              "Species",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.grey.shade700,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: .end,
                                _character?.species ?? "",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 12.w,
                          children: [
                            Text(
                              "Gender",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontSize: 15.sp,
                                    color: Colors.grey.shade700,
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                textAlign: .end,
                                _character?.gender ?? "",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacing.vertical(12),
                  Align(
                    alignment: .centerLeft,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Origin",
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
                                  _character?.originEntity?.name ?? "Unknown",
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
                  ),
                  Spacing.vertical(12),
                  Align(
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
                                  _character?.locationEntity?.name ?? "",
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
                  ),
                  Spacing.vertical(12),
                  Align(
                    alignment: .centerLeft,
                    child: Text(
                      "Episodes (${_character?.episodes?.length ?? ""})",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: REdgeInsets.symmetric(
              horizontal: AppPaddings.kDefaultPadding,
            ),
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
              itemCount: _character?.episodes?.length ?? 0,
            ),
          ),
          SliverToBoxAdapter(child: Spacing.vertical(12)),
        ],
      ),
    );
  }
}
