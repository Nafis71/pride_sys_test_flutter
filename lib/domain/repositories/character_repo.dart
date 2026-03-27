import 'package:pride_sys_test_flutter/domain/result/result.dart';

abstract class CharacterRepository {
  Future<Result> getCharacters({required int page});
}