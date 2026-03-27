import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';

abstract class ApiCharacterRepository {
  Future<ApiResponse> fetchCharacters({required int page});
}