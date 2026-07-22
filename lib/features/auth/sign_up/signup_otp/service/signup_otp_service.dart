import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class SignupOtpService {
  final ApiClient _apiClient;

  SignupOtpService(this._apiClient);

  Future<void> verifyOtp(
    String email,
    String emailOtp,
    String resetToken,
  ) async {
    final response = await _apiClient.post(Endpoint.otpVerification, {
      'email': email,
      'emailOtp': emailOtp,
      'resetToken': resetToken,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null && response.body is Map) {
        String token =
            response.body['token'] ??
            response.body['accessToken'] ??
            (response.body['data'] is Map
                ? response.body['data']['token']
                : null) ??
            "";
        if (token.isNotEmpty) {
          await _apiClient.setToken(token);
        }
      }
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
}
