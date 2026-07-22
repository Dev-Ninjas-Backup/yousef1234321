// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/auth/sign_up/service/sign_up_service.dart';

class SignUpController extends GetxController {
  final SignUpService _signUpService;

  SignUpController(this._signUpService);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Hardcoded role as CAR_OWNER
  final String role = 'CAR_OWNER';

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> signUp() async {
    if (isLoading.value) return;

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(emailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final cleanPhone = phoneController.text.trim().replaceAll(
      RegExp(r'[\s\-]'),
      '',
    );
    final phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegExp.hasMatch(cleanPhone)) {
      Get.snackbar(
        "Error",
        "Please enter a valid phone number",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        "Error",
        "Password must be at least 8 characters",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final verifyToken = await _signUpService.signUp({
        'fullName': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
        'role': role,
      });

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to OTP screen
      Get.toNamed(
        '/signupOtpScreen',
        arguments: {
          'email': emailController.text,
          'role': role,
          'verifyToken': verifyToken,
        },
      );
    } catch (e) {
      Get.snackbar(
        "Registration Failed",
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
