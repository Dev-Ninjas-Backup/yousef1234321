import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/auth/otp/binding/otp_binding.dart';
import 'package:yousef1234321/features/auth/otp/screen/otp_screen.dart';

class ResetEmailSentDialog extends StatelessWidget {
  final String email;

  const ResetEmailSentDialog({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        width: 335,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.splashButtonColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(Iconpath.email),
            ),
            const SizedBox(height: 15),
            const Text(
              "Check your email",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We’ve sent a password reset link to $email.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.subTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 120,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(
                    () => const OtpScreen(),
                    binding: OtpBinding(),
                    arguments: email,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.splashButtonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
