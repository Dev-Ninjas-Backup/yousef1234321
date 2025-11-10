import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileController extends GetxController {
  final TextEditingController firstNameController = TextEditingController(
    text: "Leonardo",
  );
  final TextEditingController lastNameController = TextEditingController(
    text: "Ahmed",
  );
  final TextEditingController locationController = TextEditingController(
    text: "Sylhet Bangladesh",
  );
  final TextEditingController phoneController = TextEditingController(
    text: "1700-212121",
  );
  final TextEditingController emailController = TextEditingController(
    text: "leonardo@gmail.com",
  );

  void saveProfile() async {
    EasyLoading.show(status: "Saving profile...");
    await Future.delayed(const Duration(seconds: 1));
    EasyLoading.showSuccess("Profile updated successfully!");
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
