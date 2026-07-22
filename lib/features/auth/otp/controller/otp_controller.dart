import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/otp/service/otp_service.dart';
import 'package:yousef1234321/routes/app_route.dart';

class OtpController extends GetxController {
  final OtpService _otpService;

  OtpController(this._otpService);

  final pinController = TextEditingController();
  final isOtpComplete = false.obs;
  final remainingSeconds = 60.obs;
  final isLoading = false.obs;
  Timer? _timer;
  late String email;

  @override
  void onInit() {
    super.onInit();
    email = Get.arguments as String;
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
      await _otpService.verifyOtp(ApiClient.to.resetToken ?? '', otp);

      Get.snackbar(
        "Success",
        "OTP Verified Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.toNamed(Approute.resetPasswordScreen);
    } catch (e) {
      Get.snackbar(
        "Verification Error",
        "Failed to verify OTP: ${e.toString().replaceAll('Exception: ', '')}",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      final resetToken = await _otpService.resendOtp(email);
      if (resetToken != null) {
        await ApiClient.to.setResetToken(resetToken);
      }
      startTimer();
      Get.snackbar("Sent", "OTP Resent successfully");
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong while resending OTP: ${e.toString().replaceAll('Exception: ', '')}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pinController.dispose();
    super.onClose();
  }
}
