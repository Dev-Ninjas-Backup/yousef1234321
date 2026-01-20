import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_controller.dart';

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({super.key, required this.controller});

  final ServiceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withValues(alpha: .05),
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.radiusController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: "radius_km".tr,
                prefixIcon: GestureDetector(
                  onTap: () => controller.loadCurrentLocation(),
                  child: Obx(() {
                    // show small spinner while fetching current location
                    if (controller.isLoadingLocation.value) {
                      return SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      );
                    }

                    // Show filled location icon if location is loaded
                    return Icon(
                      controller.hasCurrentLocation.value
                          ? Icons.location_on
                          : Icons.location_on_outlined,
                      color: AppColors.primaryColor,
                    );
                  }),
                ),

                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color.fromARGB(239, 110, 108, 108),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14),
          Obx(() {
            return GestureDetector(
              onTap: () => controller.findGaragesNearby(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: controller.isLoadingNearby.value
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : TranslatedText(
                        text: 'find_garage',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
