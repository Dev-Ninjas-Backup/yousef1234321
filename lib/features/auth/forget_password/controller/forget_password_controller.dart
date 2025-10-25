import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final emailController = TextEditingController();
  final isLoading = false.obs;
  void signIn() {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please fill in all fields");
      return;
    }
  }
}
