import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/custom_button.dart';
import 'package:yousef1234321/features/auth/otp/controller/otp_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OtpController());
    final focusNodes = List.generate(4, (_) => FocusNode());

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
                    margin: EdgeInsets.only(left: 24, top: 24),
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.splashButtonColor,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Enter the 4-digit code sent to your email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.subTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32),

                    Text(
                      "OTP Code",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: 60,
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
                              fillColor: Color(0xFFF7F7F9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            onChanged: (value) {
                              controller.onOtpChanged(index, value);

                              if (value.isNotEmpty && index < 3) {
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

                    SizedBox(height: 40),

                    Obx(
                      () => CustomButton(
                        title: "Verify OTP",
                        onPressed: controller.isOtpComplete.value
                            ? controller.verifyOtp
                            : null,
                      ),
                    ),
                    SizedBox(height: 20),

                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: controller.remainingSeconds.value == 0
                                ? controller.resendOtp
                                : null,
                            child: Text(
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
                              style: TextStyle(
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
