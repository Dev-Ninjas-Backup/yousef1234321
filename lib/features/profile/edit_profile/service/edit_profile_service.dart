import 'dart:io';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/service/network_service/network_client.dart';
import 'package:yousef1234321/core/service/network_service/network_response.dart';

class EditProfileService {
  final ApiClient _apiClient;
  final NetworkClient _networkClient;

  EditProfileService(this._apiClient)
    : _networkClient = NetworkClient(onUnAuthorize: () {});

  Future<Response> loadProfile() async {
    return await _apiClient.get(Endpoint.profile);
  }

  Future<NetworkResponse> updateProfileWithImage({
    required File file,
    required Map<String, String> extraFields,
  }) async {
    final url = '${Endpoint.baseUrl}${Endpoint.editProfile}';
    return await _networkClient.uploadFile(
      url: url,
      file: file,
      fieldName: 'file',
      extraFields: extraFields,
      method: 'PATCH',
    );
  }

  Future<NetworkResponse> updateProfile({
    required Map<String, dynamic> body,
  }) async {
    final url = '${Endpoint.baseUrl}${Endpoint.editProfile}';
    return await _networkClient.patchRequest(url: url, body: body);
  }

  String? get token => _apiClient.token;
}
