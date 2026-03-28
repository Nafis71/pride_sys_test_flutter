import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/app_padding.dart';
import 'package:pride_sys_test_flutter/common/utils/dimensions/spacing.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
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
                  CharacterBasicInfo(character: _character),
                  Spacing.vertical(12),
                  SpeciesGender(character: _character),
                  Spacing.vertical(12),
                  Origin(character: _character),
                  Spacing.vertical(12),
                  Location(character: _character),
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
          EpisodeScrollContent(character: _character),
          SliverToBoxAdapter(child: Spacing.vertical(12)),
        ],
      ),
    );
  }
}
