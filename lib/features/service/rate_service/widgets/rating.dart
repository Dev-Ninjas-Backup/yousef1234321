import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart'
    show AppColors;

import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_review_controller.dart';
import 'star_row.dart';

class Rating extends StatelessWidget {
  const Rating({super.key, required this.controller});

  final ServiceReviewController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}
