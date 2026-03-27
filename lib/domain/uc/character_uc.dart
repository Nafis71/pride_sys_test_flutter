import 'package:pride_sys_test_flutter/common/utils/logger_util.dart';
import 'package:pride_sys_test_flutter/data/models/character_m.dart';
import 'package:pride_sys_test_flutter/data/remote/repositories/api_character_repo.dart';
import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';
import 'package:pride_sys_test_flutter/domain/repositories/character_repo.dart';
import 'package:pride_sys_test_flutter/domain/result/failure.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';
import 'package:pride_sys_test_flutter/domain/result/success.dart';

class CharacterUseCase extends CharacterRepository {
  final ApiCharacterRepository _characterRepository;

  CharacterUseCase(this._characterRepository);

  @override
  Future<Result<dynamic>> getCharacters({required int page}) async {
    try {
      ApiResponse response = await _characterRepository.fetchCharacters(
        page: page,
      );
      if (response.isSuccess) {
        return Success(
          data: List.from(
            (response.data['results'] as List).map(
              (element) => CharacterModel.fromJson(element, page),
            ),
          ),
        );
      }
      return Failure(failureMessage: response.message);
    } catch (exception, stackTrace) {
      logger.e(exception, stackTrace: stackTrace);
    }
    return Failure(failureMessage: "Something went wrong");
  }
}
