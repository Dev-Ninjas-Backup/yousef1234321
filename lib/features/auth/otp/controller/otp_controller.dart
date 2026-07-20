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
  final List<FocusNode> focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
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

  void onOtpChanged(int index, String value) {
    String otp = otpControllers.map((e) => e.text).join();
    isOtpComplete.value = otp.length == 6;
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;

    String otp = otpControllers.map((e) => e.text).join();

    isLoading.value = true;

    try {
      final response = await ApiClient.to.post(Endpoint.verifyOtp, {
        "resetToken": ApiClient.to.resetToken ?? '',
        "emailOtp": otp,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Success",
          "OTP Verified Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Approute.resetPasswordScreen);
      } else {
        String errorMessage = "Invalid or incorrect OTP code";
        if (response.body != null && response.body is Map) {
          final rawMessage = response.body['message'] ??
              response.body['error'] ??
              response.body['errorMessage'];
          if (rawMessage is List && rawMessage.isNotEmpty) {
            errorMessage = rawMessage.map((e) => e.toString()).join('\n');
          } else if (rawMessage != null && rawMessage.toString().isNotEmpty) {
            errorMessage = rawMessage.toString();
          }
        } else if (response.statusText != null && response.statusText!.isNotEmpty) {
          errorMessage = response.statusText!;
        }

        Get.snackbar(
          "Verification Failed",
          errorMessage,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Verification Error",
        "Failed to verify OTP: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      final response = await ApiClient.to.post(Endpoint.forgetPassword, {
        'email': email,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null &&
            response.body['data'] != null &&
            response.body['data']['resetToken'] != null) {
          await ApiClient.to.setResetToken(response.body['data']['resetToken']);
        }
        startTimer();
        Get.snackbar("Sent", "OTP Resent successfully");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong while resending OTP: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
