import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';

import '../controller/spare_parts_controller.dart';

class PartsSearchSection extends StatelessWidget {
  PartsSearchSection({super.key});

  final SparePartsController controller = Get.find<SparePartsController>();

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
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  spacing: 5,
                  children: [
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: controller.selectedModel.value,
                          items: controller.models
                              .map(
                                (location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.selectedModel.value = value,
                          decoration: InputDecoration(
                            hintText: "Select Model",
                            hintStyle: getTextStyle(),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          initialValue: controller.selectedCategory.value,
                          items: controller.dropDownCategories
                              .map(
                                (service) => DropdownMenuItem(
                                  value: service,
                                  child: Text(service),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.selectedCategory.value = value,
                          decoration: InputDecoration(
                            hintText: "Category type",
                            hintStyle: getTextStyle(),

                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
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
                    // Get.toNamed(Approute.getfindGaragePage());
                  },
                  child: const Text("Search Parts"),
                ),
              ],
            ),
          ),

          // const SizedBox(height: 8),
          // BrandMarqueeView(),
        ],
      ),
    );
  }
}
