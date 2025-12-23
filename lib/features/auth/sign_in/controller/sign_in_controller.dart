import 'package:flutter/material.dart';
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

      final response = await ApiClient.to.post(Endpoint.login, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login response is nested inside "result"
        if (response.body != null &&
            response.body is Map &&
            response.body['result'] != null &&
            response.body['result']['data'] != null) {
          final resultData = response.body['result']['data'];
          String accessToken = resultData['token'] ?? "";

          if (accessToken.isNotEmpty) {
            await ApiClient.to.setToken(accessToken);

            Get.snackbar(
              "Success",
              "Login Successful",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Navigate to Home/Dashboard
            Get.offAllNamed(Approute.bottomNavBarScreen);
          } else {
            Get.snackbar(
              "Error",
              "Invalid token received",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Invalid response format",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Login failed with status code: ${response.statusCode}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
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
