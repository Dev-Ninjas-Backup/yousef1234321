import 'package:get/get_connect/http/src/response/response.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ContactUsService {
  final ApiClient _apiClient;

  ContactUsService(this._apiClient);

  Future<Response> getProfile() async {
    return await _apiClient.get(Endpoint.profile);
  }

  Future<Response> postContactUs(Map<String, dynamic> body) async {
    return await _apiClient.post(Endpoint.contactUs, body);
  }
}
