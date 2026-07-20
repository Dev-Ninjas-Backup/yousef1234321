import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/widget/garage_card.dart';
import 'package:yousef1234321/features/home/home_page/widget/search_section.dart';
import 'package:yousef1234321/features/home/home_page/widget/service_chip.dart';
import 'package:yousef1234321/features/notification/screen/notification_screen.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';
import 'package:yousef1234321/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:yousef1234321/features/profile/profile_page/scrreen/profile_page.dart';
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

  String _getServiceKey(String serviceName) {
    final lowerName = serviceName.toLowerCase().trim();

    if (lowerName.contains('ac') ||
        lowerName.contains('air') ||
        lowerName.contains('conditioning')) {
      return 'ac_repair';
    } else if (lowerName.contains('battery')) {
      return 'battery';
    } else if (lowerName.contains('tire') || lowerName.contains('wheel')) {
      return 'tires';
    } else if (lowerName.contains('engine')) {
      return 'engine';
    } else if (lowerName.contains('electric')) {
      return 'electrical';
    } else if (lowerName.contains('spare')) {
      return 'spares';
    }
    return serviceName;
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
                Image.asset("assets/icons/logo.png", height: 37),
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
                      child: GestureDetector(
                        onTap: () {
                          if (Get.isRegistered<BottomNavbarController>()) {
                            Get.find<BottomNavbarController>().changeIndex(4);
                          } else {
                            Get.to(() => ProfilePage());
                          }
                        },
                        child: Obx(() {
                          final profileController =
                              Get.isRegistered<ProfileController>()
                              ? Get.find<ProfileController>()
                              : Get.put(ProfileController());
                          final profilePhoto =
                              profileController.profilePhoto.value;

                          ImageProvider? backgroundImage;
                          if (profilePhoto != null && profilePhoto.isNotEmpty) {
                            backgroundImage = NetworkImage(profilePhoto);
                          }

                          return CircleAvatar(
                            backgroundImage: backgroundImage,
                            onBackgroundImageError: backgroundImage != null
                                ? (exception, stackTrace) {
                                    // Log error
                                  }
                                : null,
                            child: backgroundImage == null
                                ? const Icon(Icons.person)
                                : null,
                          );
                        }),
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
                    child: TranslatedText(
                      text: "emergency_service",
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
                    onPressed: () {
                      EasyLoading.showInfo(
                        "Emergency Service not available at the moment".tr,
                      );
                    },
                    child: TranslatedText(
                      text: "search_now",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TranslatedText(
              text: "popular_services",
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
                    children: [
                      ...services.take(3).map((service) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: ServiceChip(
                              onTap: () {
                                // Navigate to garage list with this service filter
                                Get.toNamed(
                                  Approute.getGarageListPage(),
                                  arguments: {'selectedService': service},
                                );
                              },
                              label: _getServiceKey(service).tr,
                              icon: _getIconForService(service),
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: ServiceChip(
                                onTap: () {
                                  // Navigate to garage list with this service filter
                                  Get.toNamed(
                                    Approute.getGarageListPage(),
                                    arguments: {'selectedService': service},
                                  );
                                },
                                label: _getServiceKey(service).tr,
                                icon: _getIconForService(service),
                              ),
                            ),
                          );
                        }),
                        // Fill remaining space to maintain alignment if row has < 3 items
                        ...List.generate(
                          3 - services.skip(3).take(3).length,
                          (index) => const Expanded(child: SizedBox()),
                        ),
                      ],
                    ),
                ],
              );
            }),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TranslatedText(
                  text: "top_rated_garages",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Approute.getGarageListPage());
                  },
                  child: TranslatedText(text: "view_all"),
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
                    child: TranslatedText(
                      text: 'no_garages_available',
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
