import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/routes/app_route.dart';

class OtpController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final isOtpComplete = false.obs;
  final remainingSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
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
    final email = Get.arguments;

    isLoading.value = true;

    try {
      final response = await ApiClient.to.post(Endpoint.verifyOtp, {
        "email": email,
        "otp": otp,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body['data'] != null &&
            response.body['data']['token'] != null) {
          await ApiClient.to.setToken(response.body['data']['token']);
        }
        Get.toNamed(Approute.resetPasswordScreen);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.red,
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
