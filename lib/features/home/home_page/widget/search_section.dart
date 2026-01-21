// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
          Text(
            "find_car_services_near_you".tr,
          const TranslatedText(
            text: "find_car_services_near_you",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "emergency_repairs_subtitle".tr,
          TranslatedText(
            text: "emergency_repairs_subtitle",
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
                            "location".tr,
                          hint: TranslatedText(
                            text: "location",
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
                                  child: TranslatedText(
                                    text: location,
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

                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: controller.selectedService.value,
                          hint: Text(
                            "service_type_hint".tr,
                          hint: TranslatedText(
                            text: "service_type",
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
                                          service.tr,
                                        child: TranslatedText(
                                          text: service,
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
                Obx(() {
                  final hasLocation =
                      controller.selectedLocation.value != null &&
                      controller.selectedLocation.value!.isNotEmpty;
                  final hasService =
                      controller.selectedService.value != null &&
                      controller.selectedService.value!.isNotEmpty;
                  final enabled = hasLocation && hasService;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    onPressed: enabled
                        ? () async {
                            // Attempt to get current location. If permission denied, navigate without it.
                            double? lat;
                            double? lng;
                            try {
                              EasyLoading.show(status: 'locating'.tr);
                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                              }
                              if (permission == LocationPermission.denied ||
                                  permission ==
                                      LocationPermission.deniedForever) {
                                EasyLoading.dismiss();
                                EasyLoading.showInfo(
                                  'Location permission denied',
                                );
                              } else {
                                final pos = await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high,
                                );
                                lat = pos.latitude;
                                lng = pos.longitude;
                                EasyLoading.dismiss();
                              }
                            } catch (e) {
                              EasyLoading.dismiss();
                              print('Failed to get location: $e');
                            }

                            final args = {
                              'emirate': controller.selectedLocation.value,
                              'serviceName': controller.selectedService.value,
                              if (lat != null && lng != null) 'currentLat': lat,
                              if (lat != null && lng != null) 'currentLng': lng,
                            };

                            Get.toNamed(
                              Approute.getfindGaragePage(),
                              arguments: args,
                            );
                          }
                        : null,
                    child: Text("search_garage".tr),
                    child: const TranslatedText(text: "search_garage"),
                  );
                }),
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
