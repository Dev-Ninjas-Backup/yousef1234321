// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/features/home/controller/home_controller.dart';

class SearchSection extends StatelessWidget {
  SearchSection({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          const Text(
            "Find Car Services Near You",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Emergency repairs, maintenance & more",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
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
                          items: controller.locations
                              .map(
                                (location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.selectedLocation.value = value,
                          decoration: InputDecoration(
                            hintText: "Location",
                            filled: true,
                            fillColor: Colors.grey.withValues(alpha: 0.2),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    /// 🔹 Service Type Dropdown
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedService.value,
                          items: controller.serviceTypes
                              .map(
                                (service) => DropdownMenuItem(
                                  value: service,
                                  child: Text(service),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              controller.selectedService.value = value,
                          decoration: InputDecoration(
                            hintText: "Service type",
                            filled: true,
                            fillColor: Colors.grey.withValues(alpha: 0.2),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
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
                  ),
                  onPressed: () {},
                  child: const Text("Search parts"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Image.asset(Imagepath.autoCarSlide),
        ],
      ),
    );
  }
}
