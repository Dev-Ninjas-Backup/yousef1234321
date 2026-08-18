// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/service/signup_otp_service.dart';

class SignupOtpController extends GetxController {
  final SignupOtpService _signupOtpService;

  SignupOtpController(this._signupOtpService);

  final pinController = TextEditingController();
  final isOtpComplete = false.obs;
  final remainingSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;
  String email = "";
  String verifyToken = "";

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      email = Get.arguments['email'] ?? "";
      verifyToken = Get.arguments['verifyToken'] ?? "";
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

  void onOtpChanged(String pin) {
    isOtpComplete.value = pin.length == 6;
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    String otp = pinController.text.trim();

    isLoading.value = true;
    try {
      final token = verifyToken.isNotEmpty
          ? verifyToken
          : (ApiClient.to.resetToken ?? '');
      await _signupOtpService.verifyOtp(email, otp, token);

      Get.snackbar(
        "Success",
        "OTP Verified Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/signInScreen');
    } catch (e) {
      Get.snackbar(
        "Verification Failed",
        e.toString().replaceAll("Exception: ", ""),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
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
    pinController.dispose();
    super.onClose();
  }
}
