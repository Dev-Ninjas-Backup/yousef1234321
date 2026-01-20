import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../../../../core/common/widgets/translated_text.dart';
import '../controller/service_booking_controller.dart';

class OperationHour extends StatelessWidget {
  const OperationHour({super.key, required this.controller});
  final ServiceBookingController controller;

  Map<String, dynamic> _getOpenStatus() {
    final garage = controller.garageDetail.value;
    if (garage == null) return {'isOpen': false, 'label': 'closed'};

    final now = DateTime.now();
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    final isWeekend = currentDay == 6 || currentDay == 7; // Saturday or Sunday

    String? hoursString = isWeekend
        ? garage.weekendsHours
        : garage.weekdaysHours;

    if (hoursString.isEmpty) {
      return {'isOpen': false, 'label': 'closed'};
    }

    try {
      // Parse hours like "08:00 AM - 08:00 PM"
      final parts = hoursString.split('-');
      if (parts.length != 2) {
        return {'isOpen': false, 'label': 'closed'};
      }

      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());

      if (openTime == null || closeTime == null) {
        return {'isOpen': false, 'label': 'closed'};
      }

      final currentTime = TimeOfDay.now();
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      final isOpen =
          currentMinutes >= openMinutes && currentMinutes < closeMinutes;

      return {'isOpen': isOpen, 'label': isOpen ? 'open' : 'closed'};
    } catch (e) {
      return {'isOpen': false, 'label': 'closed'};
    }
  }

  /// Parse time string like "08:00 AM" to TimeOfDay
  TimeOfDay? _parseTime(String timeStr) {
    try {
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
    final garage = controller.garageDetail.value;
    final openStatus = _getOpenStatus();
    final isOpen = openStatus['isOpen'] as bool;
    final statusLabel = openStatus['label'] as String;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          text: "operating_hours",
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TranslatedText(
              text: garage?.weekdaysHours ?? "default_weekdays_hours",
              style: getTextStyle(fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: isOpen ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TranslatedText(
                text: statusLabel,
                style: getTextStyle(
                  fontSize: 12,
                  color: isOpen ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
        if (garage != null && garage.weekendsHours.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${'weekend'.tr}: ${garage.weekendsHours}",
                style: getTextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
