// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class SignupOtpController extends GetxController {
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
      final response = await ApiClient.to.post(Endpoint.otpVerification, {
        'email': email,
        'emailOtp': otp,
        'resetToken': verifyToken.isNotEmpty ? verifyToken : (ApiClient.to.resetToken ?? ''),
      });


      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null && response.body is Map) {
          String token = response.body['token'] ??
              response.body['accessToken'] ??
              (response.body['data'] is Map ? response.body['data']['token'] : null) ??
              "";
          if (token.isNotEmpty) {
            await ApiClient.to.setToken(token);
          }
        }

        Get.snackbar(
          "Success",
          "OTP Verified Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/signInScreen');
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
