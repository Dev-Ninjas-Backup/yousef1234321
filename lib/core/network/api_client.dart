import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ApiClient extends GetConnect {
  static ApiClient get to => Get.find();
  final SharedPreferences sharedPreferences;

  ApiClient({required this.sharedPreferences});

  String? get token => sharedPreferences.getString('token');
  String? get resetToken => sharedPreferences.getString('resetToken');

  Future<bool> setToken(String? token) async {
    if (token == null) {
      return await sharedPreferences.remove('token');
    }
    final result = await sharedPreferences.setString('token', token);
    // Debug
    return result;
  }

  Future<bool> setResetToken(String? token) async {
    if (token == null) {
      return await sharedPreferences.remove('resetToken');
    }
    return await sharedPreferences.setString('resetToken', token);
  }

  /// Logout - Clear all tokens from shared preferences
  Future<void> logout() async {
    await sharedPreferences.remove('token');
    await sharedPreferences.remove('resetToken');
  }

  /// Check if user is logged in
  bool get isLoggedIn => token != null && token!.isNotEmpty;

  @override
  void onInit() {
    // Set your Swagger API Base URL here
    httpClient.baseUrl = Endpoint.baseUrl;
    httpClient.timeout = const Duration(seconds: 30);

    // Request Modifier
    httpClient.addRequestModifier<dynamic>((request) {
      final token = sharedPreferences.getString('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      // ignore: avoid_print
      print("Request: ${request.method} ${request.url}");
      return request;
    });

    // Response Modifier (Global Status Code Handling)
    httpClient.addResponseModifier((request, response) {
      // ignore: avoid_print
      print("Response: ${response.statusCode} ${response.bodyString}");
      handleGlobalStatus(response);
      return response;
    });
  }

  void handleGlobalStatus(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Global Success Logic (Optional)
      // Usually 200 is handled locally, but you can log it here.
    } else if (response.statusCode == 400) {
      // Global Bad Request Logic
      String errorMessage = "Bad Request";

      // Try to parse error message from Swagger/API response structure
      if (response.body is Map && response.body['message'] != null) {
        errorMessage = response.body['message'];
      } else if (response.bodyString != null &&
          response.bodyString!.isNotEmpty) {
        // Fallback to body string if not a JSON map
        errorMessage = response.bodyString!;
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } else if (response.statusCode == 500) {
      Get.snackbar(
        "Error",
        "Server Error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    } else {
      Get.snackbar(
        "Error",
        response.statusText ?? "Unknown Error ${response.statusCode}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }
}
