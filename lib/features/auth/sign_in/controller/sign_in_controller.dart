import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/routes/app_route.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn({String? email, String? password}) async {
    if (isLoading.value) return;

    final emailValue = (email ?? emailController.text).trim();
    final passwordValue = (password ?? passwordController.text).trim();

    if (emailValue.isEmpty || passwordValue.isEmpty) {
      EasyLoading.showError("Please enter email and password");
      return;
    }

    isLoading.value = true;

    try {
      final body = {'email': emailValue, 'password': passwordValue};

      final response = await ApiClient.to.post(Endpoint.login, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login response is nested inside "result"
        if (response.body != null &&
            response.body is Map &&
            response.body['result'] != null &&
            response.body['result']['data'] != null) {
          final resultData = response.body['result']['data'];
          String accessToken = resultData['token'] ?? "";
          String userId = resultData['user']['id'] ?? "";

          if (accessToken.isNotEmpty) {
            await ApiClient.to.setToken(accessToken);
            await ApiClient.to.setUserId(userId);

            // Get.snackbar(
            //   "Success",
            //   "Login Successful",
            //   backgroundColor: Colors.green,
            //   colorText: Colors.white,
            // );

            // Navigate to Home/Dashboard
            Get.offAllNamed(Approute.bottomNavBarScreen);
          } else {
            EasyLoading.showError("Invalid token received");
          }
        } else {
          EasyLoading.showError("Invalid response format");
        }
      } else {
        EasyLoading.showError(
          "Login failed: ${response.body['message'] ?? response.statusCode}",
        );
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
