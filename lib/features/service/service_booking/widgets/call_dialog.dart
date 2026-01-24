import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

void showCallDialog({String? garageName, String? phoneNumber}) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phone Icon
            Container(
              width: 42.w,
              height: 42.w,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, color: Colors.white, size: 20.sp),
            ),
            SizedBox(height: 14.h),

            // Title
            Text(
              "Confirm Call?".tr,
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),

            // Subtitle
            Text(
              "${"You're about to call".tr} ${garageName?.tr ?? 'this garage'.tr}",
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: 15),
            ),
            SizedBox(height: 12.h),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: SizedBox(
                    height: 36.h,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: const BorderSide(color: Color(0xFFFF3336)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Cancel".tr,
                        style: getTextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),

                // Call Now Button
                Expanded(
                  child: SizedBox(
                    height: 36.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (phoneNumber != null && phoneNumber.isNotEmpty) {
                          final Uri telUri = Uri(
                            scheme: 'tel',
                            path: phoneNumber,
                          );
                          try {
                            if (await canLaunchUrl(telUri)) {
                              await launchUrl(telUri);
                              Get.back(); // Close dialog after initiating call
                            } else {
                              Get.back();
                              Get.snackbar(
                                'Error'.tr,
                                'Cannot make phone calls on this device'.tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          } catch (e) {
                            Get.back();
                            Get.snackbar(
                              'Error'.tr,
                              '${"Failed to make call".tr}: $e',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        } else {
                          Get.back();
                          Get.snackbar(
                            'Error'.tr,
                            'Phone number not available'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, size: 16.sp, color: Colors.white),
                          SizedBox(width: 8.w),
                          Text(
                            "Call Now".tr,
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
