import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';

abstract class ApiCharacterRepository {
  /// [name] filters by character name (Rick and Morty API `name` query).
  Future<ApiResponse> fetchCharacters({required int page, String? name});
}