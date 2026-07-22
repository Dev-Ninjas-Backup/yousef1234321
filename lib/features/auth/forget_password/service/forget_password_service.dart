import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ForgetPasswordService {
  final ApiClient _apiClient;

  ForgetPasswordService(this._apiClient);

  Future<String?> requestPasswordReset(String email) async {
    final response = await _apiClient.post(Endpoint.forgetPassword, {
      'email': email,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null &&
          response.body['data'] != null &&
          response.body['data']['resetToken'] != null) {
        return response.body['data']['resetToken'];
      }
      return null;
    } else {
      _throwError(response, "Failed to process request");
    }
  }

  Future<void> resetPassword(String resetToken, String password) async {
    final response = await _apiClient.post(Endpoint.resetPassword, {
      'resetToken': resetToken,
      'password': password,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      _throwError(response, "Failed to reset password");
    }
  }

  void _throwError(Response response, String defaultMessage) {
    String errorMessage = defaultMessage;
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
    } else if (response.statusText != null && response.statusText!.isNotEmpty) {
      errorMessage = response.statusText!;
    }
    throw Exception(errorMessage);
  }
}
