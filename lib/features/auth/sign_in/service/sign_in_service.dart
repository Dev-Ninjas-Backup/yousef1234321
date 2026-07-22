import 'package:yousef1234321/features/auth/sign_in/model/auth_response_model.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class SignInService {
  final ApiClient _apiClient;

  SignInService(this._apiClient);

  Future<AuthResponseModel> signIn(String email, String password) async {
    final body = {'email': email, 'password': password};
    final response = await _apiClient.post(Endpoint.login, body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body != null &&
          response.body is Map &&
          response.body['result'] != null &&
          response.body['result']['data'] != null) {
        return AuthResponseModel.fromJson(response.body['result']['data']);
      }
      throw Exception("Invalid response format");
    } else {
      String errorMessage = "Login failed";
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
