import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final garageNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emirateController = TextEditingController();
  final serviceCategoriesController = TextEditingController();
  final garageLogoController = TextEditingController();
  final tradeLicenseController = TextEditingController();

  final roles = ['CAR_OWNER', 'GARAGE_OWNER', 'SUPER_ADMIN', 'MEMBER'].obs;
  final selectedRole = 'CAR_OWNER'.obs;

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  final garageLogoFile = Rx<File?>(null);
  final tradeLicenseFile = Rx<File?>(null);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> pickGarageLogo() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      garageLogoFile.value = File(result.files.single.path!);
    }
  }

  Future<void> pickTradeLicense() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      tradeLicenseFile.value = File(result.files.single.path!);
    }
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
        'garage_name': garageNameController.text,
        'address': addressController.text,
        'city': cityController.text,
        'emirate': emirateController.text,
        'service_categories': serviceCategoriesController.text,
        'role': selectedRole.value,
        if (selectedRole.value == 'GARAGE_OWNER' &&
            garageLogoFile.value != null)
          'logo': MultipartFile(
            garageLogoFile.value!.path,
            filename: 'logo.jpg',
            contentType: 'image/jpeg',
          ),
        if (selectedRole.value == 'GARAGE_OWNER' &&
            tradeLicenseFile.value != null)
          'license': MultipartFile(
            tradeLicenseFile.value!.path,
            filename: 'license.jpg',
            contentType: 'image/jpeg',
          ),
      });

      final response = await ApiClient.to.post('auth/register', formData);

      // Print API Response
      print("SignUp Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Extract verifyToken from Response
        String verifyToken = "";
        if (response.body is Map) {
          verifyToken = response.body['verifyToken'] ?? "";
        }

        if (verifyToken.isNotEmpty) {
          // Use verifyToken for both auth header and reset token in body
          await ApiClient.to.setToken(verifyToken);
          await ApiClient.to.setResetToken(verifyToken);
        }

        Get.snackbar(
          "Success",
          "Account created successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Pass only Email, tokens are now handled by ApiClient
        Get.toNamed(
          '/signupOtpScreen',
          arguments: {'email': emailController.text},
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
}
