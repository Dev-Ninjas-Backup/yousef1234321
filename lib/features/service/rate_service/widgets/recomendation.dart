import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_review_controller.dart';

class Recomendation extends StatelessWidget {
  const Recomendation({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceReviewController controller =
        Get.find<ServiceReviewController>();

    return Obx(() {
      final isRecommended = controller.recommendation.value;
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.recommendation.value = false;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: isRecommended ? Colors.transparent : Colors.red,
                border: Border.all(color: Colors.red, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "No",
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isRecommended ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                controller.recommendation.value = true;
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: isRecommended
                      ? Colors.green.shade400
                      : Colors.transparent,
                  border: Border.all(color: Colors.transparent, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Yes, Recommended",
                  textAlign: TextAlign.center,

                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isRecommended ? Colors.white : Colors.green.shade400,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
