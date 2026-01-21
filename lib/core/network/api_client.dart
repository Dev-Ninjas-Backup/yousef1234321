// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/routes/app_route.dart';

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
    print("Token saved: $result, Token: $token"); // Debug
    return result;
  }

  /// Permanently delete the current user account on the server.
  /// On success clears local auth data and navigates to the sign-in screen.
  Future<bool> deleteUserAccount() async {
    try {
      final response = await delete(Endpoint.deleteUUser);
      print(
        'Delete user response: ${response.statusCode} ${response.bodyString}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear local tokens / id
        await setToken(null);
        await setResetToken(null);
        await setUserId(null);

        // Navigate to sign-in screen (clear navigation stack)
        try {
          Get.offAllNamed(Approute.getSignInScreen());
        } catch (_) {}

        // Optionally show success snackbar
        Get.snackbar(
          'Success',
          response.body is Map && response.body['message'] != null
              ? response.body['message']
              : 'User account deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true;
      }

      // Let global handler show an error snackbar where appropriate
      return false;
    } catch (e, st) {
      print('Error deleting user account: $e');
      print(st);
      Get.snackbar(
        'Error',
        'Failed to delete account',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
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
    await sharedPreferences.remove('id');
    print("User logged out - tokens cleared");
  }

  String? get userId => sharedPreferences.getString('id');

  Future<bool> setUserId(String? id) async {
    if (id == null || id.isEmpty) {
      return await sharedPreferences.remove('id');
    }
    final result = await sharedPreferences.setString('id', id);
    print("User ID saved: $result, ID: $id");
    return result;
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

      print("Request: ${request.method} ${request.url}");
      return request;
    });

    // Response Modifier (Global Status Code Handling)
    httpClient.addResponseModifier((request, response) {
      print("Response: ${response.statusCode} ${response.bodyString}");
      //  handleGlobalStatus(response);
      return response;
    });
  }
}
