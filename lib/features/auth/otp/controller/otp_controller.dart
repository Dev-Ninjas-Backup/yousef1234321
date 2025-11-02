import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/routes/app_route.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  var isOtpComplete = false.obs;

  var remainingSeconds = 0.obs;
  Timer? timer;

  void onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(Get.context!).nextFocus();
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(Get.context!).previousFocus();
    }

    isOtpComplete.value = otpControllers.every(
      (controller) => controller.text.isNotEmpty,
    );
  }

  void verifyOtp() {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      Get.toNamed(Approute.getSignInScreen());
    }
  }

  void resendOtp() {
    startTimer();
  }

  void startTimer() {
    remainingSeconds.value = 30;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    timer?.cancel();
    super.onClose();
  }
}
