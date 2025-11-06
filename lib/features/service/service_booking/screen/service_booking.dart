import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/service/service_booking/controller/service_booking_controller.dart';

import '../widgets/service_booking_upper_section.dart';

class ServiceBooking extends StatelessWidget {
  final controller = Get.put(ServiceBookingController());

  ServiceBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ServiceBookingUpperSection(controller: controller),
            SizedBox(height: 24),

            //2nd
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Al Majid Auto Service",
                              style: getTextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  "4.8 (127)",
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "• 0.3 km",
                                  style: getTextStyle(
                                    fontSize: 12,
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: .1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "Towing",
                                    style: getTextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                                Text(
                                  "AC • Engine • Brakes",
                                  style: getTextStyle(
                                    fontSize: 16,
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(Iconpath.callIcon, height: 36, width: 36),
                          SizedBox(width: 10),
                          Image.asset(
                            Iconpath.messageIcon,
                            height: 36,
                            width: 36,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Location button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "See location",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Garage Overview
                  Text(
                    "Garage Overview",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Established in 2015, Al Noor Auto Garage is a certified multi-brand car service provider in Dubai. "
                    "Our expert mechanics handle everything from diagnostics to full repairs using advanced equipment and genuine parts.",
                    style: TextStyle(color: Colors.black87, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
