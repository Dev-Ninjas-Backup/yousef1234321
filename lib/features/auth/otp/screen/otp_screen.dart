import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/widgets/custom_button.dart';
import 'package:yousef1234321/features/auth/otp/controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpController>();

    final defaultPinTheme = PinTheme(
      width: 45,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F9),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.splashButtonColor, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 24),
                    child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Enter the 6-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "OTP Code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Pinput(
                        length: 6,
                        controller: controller.pinController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        showCursor: true,
                        onChanged: (value) {
                          controller.onOtpChanged(value);
                        },
                        onCompleted: (pin) {
                          controller.onOtpChanged(pin);
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    Obx(
                      () => CustomButton(
                        title: controller.isLoading.value
                            ? "Loading..."
                            : "Verify OTP",
                        onPressed:
                            (controller.isOtpComplete.value &&
                                !controller.isLoading.value)
                            ? () => controller.verifyOtp()
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: controller.remainingSeconds.value == 0
                                ? controller.resendOtp
                                : null,
                            child: const Text(
                              "Resend Code",
                              style: TextStyle(
                                color: AppColors.splashButtonColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (controller.remainingSeconds.value > 0)
                            Text(
                              "00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                color: AppColors.splashButtonColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
