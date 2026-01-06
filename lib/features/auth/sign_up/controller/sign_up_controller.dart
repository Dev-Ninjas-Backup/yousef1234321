// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class SignUpController extends GetxController {
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

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
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
      final formData = FormData({
        'fullName': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
        'role': role, // Hardcoded as CAR_OWNER
      });

      // Debug: Print form data
      // ignore: avoid_function_literals_in_foreach_calls
      formData.fields.forEach((field) {});
      print("Form Data Fields:");
      for (var field in formData.fields) {
        print("${field.key}: ${field.value}");
      }

      final response = await ApiClient.to.post(Endpoint.register, formData);

      // Print API Response

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract verifyToken from Response with null safety
        if (response.body != null && response.body is Map) {
          String verifyToken = response.body['verifyToken'] ?? "";

          if (verifyToken.isNotEmpty) {
            // Use verifyToken for both auth header and reset token
            await ApiClient.to.setToken(verifyToken);
            await ApiClient.to.setResetToken(verifyToken);

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
                'role': role, // Pass role to next screen
              },
            );
          } else {
            Get.snackbar(
              "Error",
              "Invalid verification token received",
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
          "Registration failed: ${response.body['message']}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Get.snackbar(
      //   "Error",
      //   "Something went wrong: $e",
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
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
