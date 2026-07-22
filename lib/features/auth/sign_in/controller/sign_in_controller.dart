import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_in/service/sign_in_service.dart';
import 'package:yousef1234321/routes/app_route.dart';

class SignInController extends GetxController {
  final SignInService _signInService;

  SignInController(this._signInService);

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
      final authResponse = await _signInService.signIn(
        emailValue,
        passwordValue,
      );

      if (authResponse.token.isNotEmpty) {
        await ApiClient.to.setToken(authResponse.token);
        await ApiClient.to.setUserId(authResponse.userId);

        Get.offAllNamed(Approute.bottomNavBarScreen);
      } else {
        Get.snackbar(
          "Error",
          "Invalid token received",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Failed",
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
