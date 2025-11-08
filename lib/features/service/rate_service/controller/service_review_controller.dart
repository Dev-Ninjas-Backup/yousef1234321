// service_review_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ServiceReviewController extends GetxController {
  // Star Ratings
  var overallRating = 0.obs;
  var serviceQualityRating = 0.obs;
  var timelinessRating = 0.obs;
  var valueForMoneyRating = 0.obs;

  // Feedback Text
  final feedbackController = TextEditingController();

  void setRating(String type, int value) {
    switch (type) {
      case 'overall':
        overallRating.value = value;
        break;
      case 'quality':
        serviceQualityRating.value = value;
        break;
      case 'timeliness':
        timelinessRating.value = value;
        break;
      case 'value':
        valueForMoneyRating.value = value;
        break;
    }
  }

  void submitReview() {
    if (overallRating.value == 0 ||
        serviceQualityRating.value == 0 ||
        timelinessRating.value == 0 ||
        valueForMoneyRating.value == 0) {
      EasyLoading.showToast("Incomplete, Please rate all categories");
      return;
    }

    Get.dialog(
      Dialog(child: Image.asset("assets/images/thankyou.png")),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (Get.isDialogOpen == true) Get.back();
    });

    // Optional: Reset form
    resetForm();
  }

  void resetForm() {
    overallRating.value = 0;
    serviceQualityRating.value = 0;
    timelinessRating.value = 0;
    valueForMoneyRating.value = 0;
    feedbackController.clear();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
