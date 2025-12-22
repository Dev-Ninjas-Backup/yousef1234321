import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final garageNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emirateController = TextEditingController();
  final serviceCategoriesController = TextEditingController();
  final garageLogoController = TextEditingController();
  final tradeLicenseController = TextEditingController();

  final roles = ['CAR_OWNER', 'GARAGE_OWN', 'SUPER_ADMIN', 'MEMBER'].obs;
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

  void signIn() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Login Successful!");
    });
  }
}
