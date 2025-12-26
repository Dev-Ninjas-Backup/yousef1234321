import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class SignupOtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final isOtpComplete = false.obs;
  final remainingSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;
  String email = "";

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      email = Get.arguments['email'] ?? "";
    } else {
      email = Get.arguments ?? "";
    }
    startTimer();
  }

  void startTimer() {
    remainingSeconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  void onOtpChanged(int index, String value) {
    String otp = otpControllers.map((e) => e.text).join();
    isOtpComplete.value = otp.length == 6;
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    String otp = otpControllers.map((e) => e.text).join();

    isLoading.value = true;
    try {
      final response = await ApiClient.to.post(Endpoint.otpVerification, {
        'email': email,
        'emailOtp': otp,
        'resetToken': ApiClient.to.resetToken ?? '',
      });


      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "OTP Verified Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/signInScreen');
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

  Future<void> resendOtp() async {
    startTimer();
    Get.snackbar("Sent", "OTP Resent successfully");
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
