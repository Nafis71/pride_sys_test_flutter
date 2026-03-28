import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/helpers/post_frame.dart';
import 'package:pride_sys_test_flutter/presentation/home/view_models/home_vm.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/characters_home_header.dart';
import 'package:pride_sys_test_flutter/presentation/home/widgets/home_characters_scroll_content.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeVM _homeVM = Get.find<HomeVM>();
  final ScrollController _scrollController = ScrollController();

  static const Color _scaffoldBg = Color(0xFF121212);

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

  void _showInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Characters',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Data from the Rick and Morty API. Scroll to load more characters.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          final loadingFirst =
              _homeVM.isLoading.value && _homeVM.characters.isEmpty;
          final loadingMore = _homeVM.isLoadingMore.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CharactersHomeHeader(onInfoTap: _showInfoDialog),
              Expanded(
                child: loadingFirst
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFBB86FC),
                        ),
                      )
                    : HomeCharactersScrollContent(
                        characters: _homeVM.characters,
                        scrollController: _scrollController,
                        showPaginationLoading: loadingMore,
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
