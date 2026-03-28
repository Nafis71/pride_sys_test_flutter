import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';
import 'package:pride_sys_test_flutter/common/helpers/post_frame.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';
import 'package:pride_sys_test_flutter/common/utils/routing/app_pages.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/view_models/favourites_vm.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/widgets/favourite_list_tile_w.dart';
import 'package:pride_sys_test_flutter/presentation/favourites/widgets/favourites_empty_state_w.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({super.key});

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  final FavouritesVM _favouritesVM = Get.find<FavouritesVM>();

  @override
  void initState() {
    PostFrame.executeTask(task: (){
      _favouritesVM.loadFavourites();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFAFAFA,
      appBar: AppBar(
        title: const Text('Favourites'),
        backgroundColor: AppColors.cFAFAFA,
        foregroundColor: AppColors.c1F222A,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: Obx(() {
        if (_favouritesVM.isLoading.value && _favouritesVM.favourites.isEmpty) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: Colors.grey,
            ),
          );
        }

        if (_favouritesVM.favourites.isEmpty) {
          return RefreshIndicator(
            color: AppColors.c1F222A,
            onRefresh: _favouritesVM.loadFavourites,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 0.2.sh),
                const FavouritesEmptyStateW(),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.c1F222A,
          onRefresh: _favouritesVM.loadFavourites,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _favouritesVM.favourites.length,
            separatorBuilder: (BuildContext context, int index) => RPadding(
              padding: REdgeInsets.symmetric(horizontal: AppPaddings.kDefaultPadding),
              child: Divider(
                height: 1,
                color: AppColors.black.withValues(alpha: 0.08),
              ),
            ),
            itemBuilder: (BuildContext context, int index) {
              final CharacterEntity character = _favouritesVM.favourites[index];
              return FavouriteListTileW(
                character: character,
                onTap: () async {
                  await Get.toNamed(
                    AppPages.characterDetails,
                    arguments: <String, dynamic>{'character': character},
                  );
                  await _favouritesVM.loadFavourites();
                },
              );
            },
          ),
        );
      }),
    );
  }
}
