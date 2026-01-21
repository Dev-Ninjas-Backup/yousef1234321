import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/routes/app_route.dart';
import '../controller/service_controller.dart';
import '../model/garage_model.dart';
import '../widgets/search_and_filter.dart';

class FindService extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());

  FindService({super.key});

  /// Check if garage is currently open based on operating hours
  Map<String, dynamic> _getOpenStatus(GarageModel garage) {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    final isWeekend = currentDay == 6 || currentDay == 7; // Saturday or Sunday

    String? hoursString = isWeekend
        ? garage.weekendsHours
        : garage.weekdaysHours;

    if (hoursString == null || hoursString.isEmpty) {
      return {'isOpen': false, 'label': 'closed'};
    }

    try {
      // Parse hours like "08:00 AM - 08:00 PM"
      final parts = hoursString.split('-');
      if (parts.length != 2) return {'isOpen': false, 'label': 'closed'};

      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());

      if (openTime == null || closeTime == null) {
        return {'isOpen': false, 'label': 'closed'};
      }

      final currentTime = TimeOfDay.now();
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      // Handle normal and overnight ranges correctly
      bool isOpen;
      if (closeMinutes > openMinutes) {
        // same-day range
        isOpen = currentMinutes >= openMinutes && currentMinutes < closeMinutes;
      } else {
        // overnight range (e.g. 8:00 PM - 4:00 AM)
        isOpen = currentMinutes >= openMinutes || currentMinutes < closeMinutes;
      }

      return {'isOpen': isOpen, 'label': isOpen ? 'open' : 'closed'};
    } catch (e) {
      return {'isOpen': false, 'label': 'closed'};
    }
  }

  TimeOfDay? _parseTime(String timeStr) {
    try {
      // Expected format: "08:00 AM" or "8:00 PM"
      final parts = timeStr.split(' ');
      if (parts.length != 2) return null;

      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return null;

      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 52, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(title: "find_service"),
            const SizedBox(height: 32),
            SearchAndFilter(controller: controller),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TranslatedText(
                  text: 'nearby_garages',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // Optional: Navigate to full garage list
                //   },
                //   child: Text(
                //     "View All",
                //     style: getTextStyle(
                //       color: AppColors.splashButtonColor,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    // Optional: Navigate to full garage list
                  },
                  child: TranslatedText(
                    text: 'view_all',
                    style: getTextStyle(
                      color: AppColors.splashButtonColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Expanded list for garages only
            Expanded(
              child: Obx(() {
                if (controller.isLoadingNearby.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.garages.isEmpty) {
                  return Center(
                    child: TranslatedText(
                      text: 'no_garages_available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                final List<GarageModel> list = controller.garages.toList(
                  growable: false,
                );

                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final g = list[index];
                    final String name = g.name;
                    final String? profileImage = g.profileImage;
                    final String distance = g.distance?.toString() ?? '';

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Approute.getServiceBooking(),
                          arguments: {'garageId': g.id},
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image:
                                      (profileImage != null &&
                                          profileImage.isNotEmpty)
                                      ? NetworkImage(profileImage)
                                      : AssetImage(Imagepath.onboarding1)
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TranslatedText(
                                        text: name,
                                        style: getTextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Color(0xFF2ECC71),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${g.averageRating ?? 0} (${g.totalReviews ?? 0})",
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: AppColors.subTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: AppColors.subTextColor,
                                      ),
                                      const SizedBox(width: 8),
                                      TranslatedText(
                                        text: 'distance_km'.tr.replaceAll(
                                          '@distance',
                                          distance,
                                        ),
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: AppColors.subTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Builder(
                                        builder: (context) {
                                          final openStatus = _getOpenStatus(g);
                                          final isOpen =
                                              openStatus['isOpen'] as bool;
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: isOpen
                                                  ? const Color(0xFFDCFCE7)
                                                  : const Color(0xFFF3F4F6),
                                            ),
                                            child: TranslatedText(
                                              text: isOpen ? 'open' : 'closed',
                                              style: getTextStyle(
                                                fontSize: 12,
                                                color: isOpen
                                                    ? const Color(0xFF2ECC71)
                                                    : AppColors.subTextColor,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),
                                  // Open / Closed badge for this garage
                                  Row(children: [
                                      
                                    ],
                                  ),

                                  const SizedBox(height: 6),
                                  TranslatedText(
                                    text: g.address ?? '',
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: AppColors.subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
