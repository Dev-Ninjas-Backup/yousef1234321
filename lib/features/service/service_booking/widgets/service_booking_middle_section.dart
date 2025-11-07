import 'package:flutter/material.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/call_dialog.dart';
import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/constants/iconpath.dart';
import '../../../../core/common/style/global_text_style.dart';

class ServiceBookingMiddleSection extends StatelessWidget {
  const ServiceBookingMiddleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      Icon(Icons.circle, size: 8, color: Colors.green),
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
                          style: getTextStyle(color: Colors.blue, fontSize: 12),
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
                GestureDetector(
                  onTap: () {
                    showCallDialog();
                  },
                  child: Image.asset(Iconpath.callIcon, height: 36, width: 36),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    Iconpath.messageIcon,
                    height: 36,
                    width: 36,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        // Location button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          ),
          onPressed: () {},
          icon: const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: Colors.white,
          ),
          label: Text(
            "See location",
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Garage Overview
        Text(
          "Garage Overview",
          style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 14),
        Text(
          "Established in 2015, Al Noor Auto Garage is a certified multi-brand car service provider in Dubai. "
          "Our expert mechanics handle everything from diagnostics to full repairs using advanced equipment and genuine parts.",
          style: getTextStyle(color: AppColors.subTextColor, fontSize: 12),
        ),
      ],
    );
  }
}
