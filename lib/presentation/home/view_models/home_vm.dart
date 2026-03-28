import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_page_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/result/failure.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';
import 'package:pride_sys_test_flutter/domain/result/success.dart';
import 'package:pride_sys_test_flutter/presentation/common/common_toast.dart';

class HomeVM extends GetxController {
  RxList<CharacterEntity> characters = RxList();
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = true.obs;
  int _currentPage = 1;
  final CharacterRepository _characterRepository;

  HomeVM(this._characterRepository);

  Future<void> loadCharacters({bool loadMore = false}) async {
    if (isLoading.value || isLoadingMore.value) return;
    if (loadMore && !hasMore.value) return;

    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        _currentPage = 1;
        characters.clear();
        hasMore.value = true;
      }
      final Result<CharacterPageEntity> result =
          await _characterRepository.getCharacters(page: _currentPage);
      switch (result) {
        case Failure<CharacterPageEntity>(:final failureMessage):
          CommonToast.show(
            context: Get.context,
            title: failureMessage?.toString() ?? 'Request failed',
          );
          return;
        case Success<CharacterPageEntity>(:final data):
          final page = data;
          if (page == null) return;
          if (loadMore) {
            characters.addAll(page.characters);
          } else {
            characters.assignAll(page.characters);
          }
          hasMore.value = page.hasMore;
          _currentPage++;
          logger.i(
            'Character list length : ${characters.length}, fetched page: ${_currentPage - 1}, hasMore: ${page.hasMore}',
          );
      }
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
