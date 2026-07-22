import 'package:get/get_connect/http/src/response/response.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ProfileService {
  final ApiClient _apiClient;

  ProfileService(this._apiClient);

  Future<Response> fetchProfile() async {
    return await _apiClient.get(Endpoint.profile);
  }

  Future<void> logout() async {
    await _apiClient.logout();
  }
}
