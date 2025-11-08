import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/service/rate_service/controller/service_review_controller.dart'
    show ServiceReviewController;

import '../widgets/add_photos.dart';
import '../widgets/rating.dart';
import '../widgets/recomendation.dart';

class ServiceReviewScreen extends StatelessWidget {
  ServiceReviewScreen({super.key});
  final ServiceReviewController controller = Get.put(ServiceReviewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "Rate Service"),
            SizedBox(height: 30),
            //rating
            Rating(controller: controller),

            SizedBox(height: 25),

            // Additional Feedback
            Text(
              "Additional Feedback",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            Text(
              "Your comments help us improve future experiences.",
              style: getTextStyle(fontSize: 12),
            ),
            SizedBox(height: 8),

            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFE8F1FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.feedbackController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Tell us more about your experience",
                  hintStyle: getTextStyle(
                    fontSize: 16,
                    color: Color(0xFF7F8C8D),
                  ),
                  border: InputBorder.none,
                ),
                style: getTextStyle(fontSize: 14),
              ),
            ),

            SizedBox(height: 24),

            // Add Photos
            Text(
              "Add Photos (Optional)",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),

            AddPhotos(controller: controller),

            SizedBox(height: 25),

            // Recommendation
            Text(
              "Recommendation",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            Text(
              "Your comments help us improve future experiences.",
              style: getTextStyle(fontSize: 12),
            ),
            SizedBox(height: 25),

            Recomendation(),
            SizedBox(height: 35.h),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Submit Review",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
