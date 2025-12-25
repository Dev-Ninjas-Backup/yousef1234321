// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/widget/brand_marque.dart';

import '../../../../routes/app_route.dart';

class SearchSection extends StatelessWidget {
  SearchSection({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Find Car Services Near You",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Emergency repairs, maintenance & more",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    /// 🔹 Location Dropdown
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedLocation.value,
                          isExpanded: true,
                          hint: Text(
                            "Location",
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          items: controller.locations
                              .map(
                                (location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(
                                    location,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.selectedLocation.value = value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    /// 🔹 Service Type Dropdown
                    Expanded(
                      child: Obx(() {
                        // Debug print
                        print(
                          'Service Types available: ${controller.serviceTypes}',
                        );
                        print(
                          'Service Types length: ${controller.serviceTypes.length}',
                        );
                        print(
                          'Selected service: ${controller.selectedService.value}',
                        );

                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: controller.selectedService.value,
                          hint: Text(
                            "Service type",
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                          items: controller.serviceTypes.isEmpty
                              ? null
                              : controller.serviceTypes
                                    .map(
                                      (service) => DropdownMenuItem(
                                        value: service,
                                        child: Text(
                                          service,
                                          style: getTextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          onChanged: controller.serviceTypes.isEmpty
                              ? null
                              : (value) =>
                                    controller.selectedService.value = value,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.toNamed(Approute.getfindGaragePage());
                  },
                  child: const Text("Search garage"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          BrandMarqueeView(),
        ],
      ),
    );
  }
}
