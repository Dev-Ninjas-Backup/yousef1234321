import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/forget_password/service/forget_password_service.dart';
import 'package:yousef1234321/features/auth/forget_password/widgets/reset_email_sent_dialog.dart';

class ForgetPasswordController extends GetxController {
  final ForgetPasswordService _forgetPasswordService;

  ForgetPasswordController(this._forgetPasswordService);

  final emailController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> resetPasswordDialog() async {
    if (isLoading.value) return;

    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      final resetToken = await _forgetPasswordService.requestPasswordReset(
        email,
      );

      if (resetToken != null) {
        await ApiClient.to.setResetToken(resetToken);
      }

      Get.dialog(
        ResetEmailSentDialog(email: email),
        barrierDismissible: true,
        // ignore: deprecated_member_use
        barrierColor: Colors.black.withValues(alpha: 0.5),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
