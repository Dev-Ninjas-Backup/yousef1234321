import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/widget/garage_card.dart';
import 'package:yousef1234321/features/home/home_page/widget/search_section.dart';
import 'package:yousef1234321/features/home/home_page/widget/service_chip.dart';
import 'package:yousef1234321/features/notification/screen/notification_screen.dart';
import 'package:yousef1234321/routes/app_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getIconForService(String serviceName) {
    final lowerName = serviceName.toLowerCase().trim();

    // AC & Air Conditioning
    if (lowerName.contains('ac') ||
        lowerName.contains('air') ||
        lowerName.contains('conditioning') ||
        lowerName.contains('cooling')) {
      return Iconpath.acIcon;
    }
    // Battery
    else if (lowerName.contains('battery') || lowerName.contains('batteries')) {
      return Iconpath.batterryIcon;
    }
    // Tires & Wheels
    else if (lowerName.contains('tire') ||
        lowerName.contains('tyre') ||
        lowerName.contains('wheel')) {
      return Iconpath.wheelIcon;
    }
    // Engine
    else if (lowerName.contains('engine') ||
        lowerName.contains('motor') ||
        lowerName.contains('diagnostic')) {
      return Iconpath.engineIcon;
    }
    // Electrical
    else if (lowerName.contains('electric') ||
        lowerName.contains('wiring') ||
        lowerName.contains('lighting')) {
      return Iconpath.electricIcon;
    }
    // Brakes
    else if (lowerName.contains('brake') || lowerName.contains('braking')) {
      return Iconpath.wheelIcon;
    }
    // Oil
    else if (lowerName.contains('oil') ||
        lowerName.contains('fluid') ||
        lowerName.contains('lubrication')) {
      return Iconpath.engineIcon;
    }
    // Spare parts
    else if (lowerName.contains('spare') || lowerName.contains('part')) {
      return Iconpath.spareIcon;
    }
    // Default
    else {
      return Iconpath.engineIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    // ignore: unused_local_variable

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Iconpath.carHomeIcon, height: 37, width: 37),
                    SizedBox(width: 8),
                    Text(
                      "sayara_hub".tr,
                      style: getTextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Tooltip(
                      message: "notifications".tr,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => NotificationScreen());
                          },
                          child: Image.asset(Iconpath.notification, scale: 2),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Tooltip(
                      message: "profile".tr,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SearchSection(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "emergency_service".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "search_now".tr,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "popular_services".tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Obx(() {
              // Get services from controller, limit to 6
              final services = controller.serviceTypes.take(6).toList();

              if (services.isEmpty) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              return Column(
                children: [
                  // First row: up to 3 services
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...services.take(3).map((service) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to garage list with this service filter
                              Get.toNamed(
                                Approute.getGarageListPage(),
                                arguments: {'selectedService': service},
                              );
                            },
                            child: Center(
                              child: ServiceChip(
                                label: service.tr,
                                icon: _getIconForService(service),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Second row: remaining services (if more than 3)
                  if (services.length > 3)
                    Row(
                      children: [
                        ...services.skip(3).take(3).map((service) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to garage list with this service filter
                                Get.toNamed(
                                  Approute.getGarageListPage(),
                                  arguments: {'selectedService': service},
                                );
                              },
                              child: Center(
                                child: ServiceChip(
                                  label: service.tr,
                                  icon: _getIconForService(service),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              );
            }),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "top_rated_garages".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Approute.getGarageListPage());
                  },
                  child: Text("view_all".tr),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoadingGarages.value) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.garages.isEmpty) {
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'no_garages_available'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: controller.garages
                    .map((garage) => GarageCard(garage: garage))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
