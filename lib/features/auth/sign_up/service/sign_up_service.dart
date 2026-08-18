import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class SignUpService {
  final ApiClient _apiClient;

  SignUpService(this._apiClient);

  Future<String> signUp(Map<String, dynamic> data) async {
    final formData = FormData(data);
    final response = await _apiClient.post(Endpoint.register, formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null && response.body is Map) {
        String verifyToken = response.body['verifyToken'] ?? "";
        if (verifyToken.isNotEmpty) {
          return verifyToken;
        }
      }
      throw Exception("Invalid response format or verification token missing");
    } else {
      String errorMessage = "Registration failed";
      if (response.body != null && response.body is Map) {
        final rawMessage =
            response.body['message'] ??
            response.body['error'] ??
            response.body['errorMessage'];
        if (rawMessage is List && rawMessage.isNotEmpty) {
          errorMessage = rawMessage.map((e) => e.toString()).join('\n');
        } else if (rawMessage != null && rawMessage.toString().isNotEmpty) {
          errorMessage = rawMessage.toString();
        }
      } else if (response.statusText != null &&
          response.statusText!.isNotEmpty) {
        errorMessage = response.statusText!;
      }
      throw Exception(errorMessage);
    }
  }
}
