import 'package:pride_sys_test_flutter/domain/entities/character_page_e.dart';
import 'package:pride_sys_test_flutter/domain/result/result.dart';

abstract class CharacterRepository {
  Future<Result<CharacterPageEntity>> getCharacters({required int page});
}