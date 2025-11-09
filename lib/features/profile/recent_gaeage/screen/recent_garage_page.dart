import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/recent_gaeage/controller/recent_garage_controller.dart';
import 'package:yousef1234321/features/profile/recent_gaeage/widgets/recent_garage_card.dart';
import 'package:yousef1234321/features/service/rate_service/screen/service_review_scree.dart';

class RecentGaragePage extends StatelessWidget {
  final controller = Get.put(RecentGarageController());
  RecentGaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          children: [
            CustomAppBar(title: "Recent Garage"),

            SizedBox(height: 50),
            Obx(
              () => Column(
                children: controller.garages
                    .map((garage) => RecentGarageCard(garage: garage))
                    .toList(),
              ),
            ),

            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Get.to(ServiceReviewScreen());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor, width: 1),

                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "Write a Review",
                    style: getTextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor,
                    ),
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
