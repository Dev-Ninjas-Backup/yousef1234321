import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn() async {
    if (isLoading.value) return;

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      };

      final response = await ApiClient.to.post('auth/login', body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract and save tokens from login response
        if (response.body is Map) {
          String accessToken = response.body['data']?['accessToken'] ??
              response.body['accessToken'] ??
              response.body['token'] ??
              "";
          String resetToken = response.body['data']?['resetToken'] ??
              response.body['verifyToken'] ??
              "";

          if (accessToken.isNotEmpty) {
            await ApiClient.to.setToken(accessToken);
          }
          if (resetToken.isNotEmpty) {
            await ApiClient.to.setResetToken(resetToken);
          }
        }

        Get.snackbar(
          "Success",
          "Login Successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to Home/Dashboard
        Get.offAllNamed('/bottomNavbarScreen');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
