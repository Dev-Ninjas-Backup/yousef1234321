import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/custom_button.dart';
import 'package:yousef1234321/features/auth/otp/controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpController>();
    final focusNodes = List.generate(6, (_) => FocusNode());

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
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, top: 24),
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.splashButtonColor,
                      ),
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) => SizedBox(
                          width: 45,
                          height: 70,
                          child: TextField(
                            controller: controller.otpControllers[index],
                            focusNode: focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: "",
                              filled: true,
                              fillColor: const Color(0xFFF7F7F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              controller.onOtpChanged(index, value);

                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(focusNodes[index - 1]);
                              }
                            },
                          ),
                        ),
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
