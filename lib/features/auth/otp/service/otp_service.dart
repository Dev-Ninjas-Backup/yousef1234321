import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class OtpService {
  final ApiClient _apiClient;

  OtpService(this._apiClient);

  Future<void> verifyOtp(String resetToken, String emailOtp) async {
    final response = await _apiClient.post(Endpoint.verifyOtp, {
      "resetToken": resetToken,
      "emailOtp": emailOtp,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    } else {
      String errorMessage = "Invalid or incorrect OTP code";
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

  Future<String?> resendOtp(String email) async {
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
      throw Exception("Failed to resend OTP");
    }
  }
}
