import 'package:pride_sys_test_flutter/data/remote/config/api_endpoints.dart';
import 'package:pride_sys_test_flutter/data/remote/controller/network_c.dart';
import 'package:pride_sys_test_flutter/data/remote/repositories/api_character_repo.dart';
import 'package:pride_sys_test_flutter/data/remote/response/api_response.dart';

class ApiCharacterRequest extends ApiCharacterRepository {
  final NetworkController _networkController;

  ApiCharacterRequest(this._networkController);

  @override
  Future<ApiResponse<dynamic>> fetchCharacters({required int page}) {
    return _networkController.request(
      url: ApiEndPoints.characterUrl,
      method: Method.get,
      params: {'page': page},
    );
  }
}
