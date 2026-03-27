import 'package:get/get.dart';
import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/domain/entities/character_e.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/result/failure.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';
import 'package:pride_sys_test_flutter/domain/result/success.dart';
import 'package:pride_sys_test_flutter/presentation/common/common_toast.dart';

class HomeVM extends GetxController {
  RxList<CharacterEntity> characters = RxList();
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMore = false.obs;
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
      Result result = await _characterRepository.getCharacters(
        page: _currentPage,
      );
      if (result is Failure) {
        return CommonToast.show(
          context: Get.context,
          title: result.failureMessage.toString(),
        );
      }
      List<CharacterEntity> newCharacters = (result as Success).data;
      if(loadMore){
        characters.addAll(newCharacters);
      } else{
        characters.assignAll(newCharacters);
      }
      _currentPage++;
      logger.i(
        "Character list length : ${characters.length}, Current Page: $_currentPage",
      );
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    } finally{
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
