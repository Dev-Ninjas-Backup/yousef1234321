import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocationPageController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  void setDefaultLocation() {
    Get.snackbar(
      "Success",
      "Default location set successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
