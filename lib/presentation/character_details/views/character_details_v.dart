import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/colors/app_colors.dart';
import 'package:pride_sys_test_flutter/common/helpers/post_frame.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/spacing.dart';
import 'package:pride_sys_test_flutter/common/utils/routing/app_pages.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/view_models/character_details_vm.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/character_basic_info_w.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/episode_scroll_content_w.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/location_w.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/origin_w.dart';
import 'package:pride_sys_test_flutter/presentation/character_details/widgets/species_gender_w.dart';
import 'package:pride_sys_test_flutter/presentation/common/network_image_loader_w.dart';

class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({super.key});

  @override
  State<CharacterDetailsView> createState() => _CharacterDetailsViewState();
}

class _CharacterDetailsViewState extends State<CharacterDetailsView> {
  late final Map<String, dynamic>? _arguments;
  final CharacterDetailsVM _characterDetailsVM = Get.find();

  @override
  void initState() {
    super.initState();
    _arguments = Get.arguments;
    final CharacterEntity? fromRoute = _arguments?['character'] as CharacterEntity?;
    _characterDetailsVM.bindCharacter(fromRoute);
    PostFrame.executeTask(
      task: () {
        _characterDetailsVM.isFavourite(id: fromRoute?.id);
      },
    );
  }

  Future<void> _openEdit() async {
    final CharacterEntity? c = _characterDetailsVM.character.value;
    if (c == null) return;
    await Get.toNamed(
      AppPages.editCharacterDetails,
      arguments: <String, dynamic>{'character': c},
    );
    await _characterDetailsVM.refreshCharacter();
    await _characterDetailsVM.isFavourite(id: _characterDetailsVM.character.value?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final CharacterEntity? character = _characterDetailsVM.character.value;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            character?.name ?? '',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            RPadding(
              padding: REdgeInsets.symmetric(
                horizontal: AppPaddings.kDefaultPadding,
              ),
              child: Row(
                spacing: 12.w,
                children: [
                  GestureDetector(
                    onTap: _openEdit,
                    child: Icon(
                      Icons.edit,
                      size: 26.r,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        _characterDetailsVM.toggleFavourites(character?.id),
                    child: Obx(
                      () => Icon(
                        _characterDetailsVM.isSelectedCharacterIsFavourite.value
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        size: 26.r,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: character == null
            ? const Center(child: Text('No character'))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: NetworkImageLoader(url: character.image),
                  ),
                  SliverToBoxAdapter(
                    child: RPadding(
                      padding: REdgeInsets.all(AppPaddings.kDefaultPadding),
                      child: Column(
                        children: [
                          CharacterBasicInfo(character: character),
                          Spacing.vertical(12),
                          SpeciesGender(character: character),
                          Spacing.vertical(12),
                          Origin(character: character),
                          Spacing.vertical(12),
                          Location(character: character),
                          Spacing.vertical(12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Episodes (${character.episodes?.length ?? ''})',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  EpisodeScrollContent(character: character),
                  SliverToBoxAdapter(child: Spacing.vertical(12)),
                ],
              ),
      );
    });
  }
}
