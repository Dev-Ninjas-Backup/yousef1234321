import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  void sendMessage() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      Get.snackbar("Error", "Please fill all fields before sending.");
      return;
    }

    Get.snackbar("Success", "Your message has been sent!");
    nameController.clear();
    emailController.clear();
    messageController.clear();
  }
}
