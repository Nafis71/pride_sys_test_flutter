import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';

import 'character_card.dart';
import 'character_grid_loading_footer.dart';

/// Scrollable 3-column grid + optional pagination footer sliver.
class HomeCharactersScrollContent extends StatelessWidget {
  const HomeCharactersScrollContent({
    super.key,
    required this.characters,
    required this.scrollController,
    required this.showPaginationLoading,
  });

  final List<CharacterEntity> characters;
  final ScrollController scrollController;
  final bool showPaginationLoading;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6.w,
              mainAxisSpacing: 6.h,
              childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final character = characters[index];
                return CharacterCard(
                  character: character,
                  onTap: (){},
                );
              },
              childCount: characters.length,
            ),
          ),
        ),
        if (showPaginationLoading)
          const SliverToBoxAdapter(child: CharacterGridLoadingFooter()),
      ],
    );
  }
}
