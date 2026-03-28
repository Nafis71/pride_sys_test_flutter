import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/helpers/post_frame.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/presentation/home/helpers/home_helper.dart';
import 'package:pride_sys_test_flutter/presentation/home/view_models/home_vm.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/characters_home_header.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/home_character_search_field_w.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/home_characters_scroll_content.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/home_empty_state_w.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeVM _homeVM = Get.find<HomeVM>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    PostFrame.executeTask(
      task: () {
        _scrollController.addListener(_onScroll);
        if (_homeVM.characters.isEmpty && !_homeVM.isLoading.value) {
          _homeVM.loadCharacters();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      _homeVM.loadCharacters(loadMore: true);
    }
  }

  void _onSearchQueryChanged(String query) {
    _homeVM.applySearchQuery(query);
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final bool firstLoading =
              _homeVM.isLoading.value && _homeVM.characters.isEmpty;
          final bool loadingMore = _homeVM.isLoadingMore.value;
          final String searchTrimmed = _homeVM.searchQuery.value.trim();
          final List<CharacterEntity> gridCharacters = _homeVM.charactersForDisplay;
          final bool noSearchResults =
              searchTrimmed.isNotEmpty && !firstLoading && gridCharacters.isEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CharactersHomeHeader(
                onRestoreTap: () {
                  HomeHelper.showRestoreAllDialog(context: context);
                },
              ),
              HomeCharacterSearchFieldW(
                onQueryChanged: _onSearchQueryChanged,
              ),
              Expanded(
                child: firstLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(color: Colors.grey),
                      )
                    : noSearchResults
                        ? Center(
                            child: Text(
                              'No characters found for "$searchTrimmed".',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : gridCharacters.isNotEmpty ? HomeCharactersScrollContent(
                            characters: gridCharacters,
                            scrollController: _scrollController,
                            showPaginationLoading: loadingMore,
                          ) : HomeEmptyState(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
