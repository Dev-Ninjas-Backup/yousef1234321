import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/routes/app_route.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    if (isLoading.value) return;

    final password = passwordController.text.trim();

    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a new password",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 8) {
      Get.snackbar(
        "Error",
        "Password must be at least 8 characters",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiClient.to.post(Endpoint.resetPassword, {
        'resetToken': ApiClient.to.resetToken ?? '',
        'password': password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "Password reset successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed(Approute.signInScreen);
      } else {
        String errorMessage = "Failed to reset password";
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

        Get.snackbar(
          "Error",
          errorMessage,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
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
    passwordController.dispose();
    super.onClose();
  }
}
