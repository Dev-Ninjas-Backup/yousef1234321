import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/service/rate_service/controller/service_review_controller.dart'
    show ServiceReviewController;
import 'package:yousef1234321/features/service/rate_service/widgets/star_row.dart';

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
            Text(
              "Rate Your Service Experience",
              style: getTextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your feedback helps us improve and ensure you always get the best car care experience.",
              style: getTextStyle(color: AppColors.subTextColor),
            ),
            SizedBox(height: 25),
            // 1. Overall Experience
            Text(
              "1. How was your overall experience?",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            Obx(
              () => starRow(
                controller.overallRating,
                (v) => controller.setRating('overall', v),
              ),
            ),
            SizedBox(height: 8),
            // 2. Service Quality
            Text(
              "2. Service Quality",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 12),
            Obx(
              () => starRow(
                controller.serviceQualityRating,
                (v) => controller.setRating('quality', v),
              ),
            ),
            SizedBox(height: 8),

            // 3. Timeliness
            Text(
              "3. Timeliness",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 12),
            Obx(
              () => starRow(
                controller.timelinessRating,
                (v) => controller.setRating('timeliness', v),
              ),
            ),
            SizedBox(height: 8),

            // 4. Value for Money
            Text(
              "4. Value for Money",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 12),
            Obx(
              () => starRow(
                controller.valueForMoneyRating,
                (v) => controller.setRating('value', v),
              ),
            ),
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

            SizedBox(height: 24.h),

            // Add Photos
            Text(
              "Add Photos (Optional)",
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                //controller.hasPhoto.value = true;
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 6,
                      spreadRadius: 0,
                      color: Color(0xFF000000).withValues(alpha: .22),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_sharp,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(height: 6),
                      Text("Add Photo", style: getTextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

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

Row(
spacing: 12,
  children: [
    GestureDetector(
          onTap: (){},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              // color:Colors.amber,
              border: Border.all(
                color: Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "No",
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red
              ),
            ),
          ),
        ),
        Expanded(child:     GestureDetector(
          onTap: (){},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
               color:Colors.green[400],
              border: Border.all(
                color: Colors.transparent,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Yes, Recommended",
              textAlign: TextAlign.center,

              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
              ),
            ),
          ),
        ),)
  ],
),
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
