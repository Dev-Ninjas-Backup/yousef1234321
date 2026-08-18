import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/forget_password/service/forget_password_service.dart';
import 'package:yousef1234321/routes/app_route.dart';

class ResetPasswordController extends GetxController {
  final ForgetPasswordService _forgetPasswordService;

  ResetPasswordController(this._forgetPasswordService);

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
      await _forgetPasswordService.resetPassword(
        ApiClient.to.resetToken ?? '',
        password,
      );

      Get.snackbar(
        "Success",
        "Password reset successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Approute.signInScreen);
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
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
