import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';
import 'package:yousef1234321/routes/app_route.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

class GarageCard extends StatelessWidget {
  final GarageModel garage;

  const GarageCard({super.key, required this.garage});

  Map<String, String>? _parseHoursJson(String? hoursStr) {
    if (hoursStr == null || hoursStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(hoursStr);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return null;
  }

  String? _getHoursForToday() {
    final now = DateTime.now();
    final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
    
    // Map weekday number to string name
    const weekdayNames = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday',
    };
    final todayName = weekdayNames[currentDay]!;
    
    // Try to get from weekdaysHours first if it is JSON
    final weekdaysParsed = _parseHoursJson(garage.weekdaysHours);
    if (weekdaysParsed != null) {
      final key = weekdaysParsed.keys.firstWhere(
        (k) => k.toLowerCase() == todayName.toLowerCase(),
        orElse: () => '',
      );
      if (key.isNotEmpty) return weekdaysParsed[key];
    }
    
    // Try weekendsHours if it is JSON
    final weekendsParsed = _parseHoursJson(garage.weekendsHours);
    if (weekendsParsed != null) {
      final key = weekendsParsed.keys.firstWhere(
        (k) => k.toLowerCase() == todayName.toLowerCase(),
        orElse: () => '',
      );
      if (key.isNotEmpty) return weekendsParsed[key];
    }
    
    // If not JSON, fallback to traditional check
    final isWeekend = currentDay == 6 || currentDay == 7;
    final hoursString = isWeekend ? garage.weekendsHours : garage.weekdaysHours;
    return hoursString != null && hoursString.isNotEmpty ? hoursString : null;
  }

  /// Check if garage is currently open based on time
  Map<String, dynamic> _getOpenStatus() {
    final hoursString = _getHoursForToday();
    if (hoursString == null || hoursString.isEmpty || hoursString.toLowerCase() == 'closed') {
      return {'isOpen': false, 'label': 'Closed'};
    }

    try {
      // Parse hours like "08:00 AM - 08:00 PM"
      final parts = hoursString.split('-');
      if (parts.length != 2) {
        return {'isOpen': false, 'label': 'Closed'};
      }

      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());

      if (openTime == null || closeTime == null) {
        return {'isOpen': false, 'label': 'Closed'};
      }

      final currentTime = TimeOfDay.now();
      final currentMinutes = currentTime.hour * 60 + currentTime.minute;
      final openMinutes = openTime.hour * 60 + openTime.minute;
      final closeMinutes = closeTime.hour * 60 + closeTime.minute;

      // Handle normal and overnight ranges correctly
      bool isOpen;
      if (closeMinutes > openMinutes) {
        // same-day range (e.g. 8:00 AM - 8:00 PM)
        isOpen = currentMinutes >= openMinutes && currentMinutes < closeMinutes;
      } else {
        // overnight range (e.g. 8:00 PM - 4:00 AM)
        isOpen = currentMinutes >= openMinutes || currentMinutes < closeMinutes;
      }

      return {'isOpen': isOpen, 'label': isOpen ? 'Open' : 'Closed'};
    } catch (e) {
      return {'isOpen': false, 'label': 'Closed'};
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
    final openStatus = _getOpenStatus();
    final isOpen = openStatus['isOpen'] as bool;
    final statusLabel = openStatus['label'] as String;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Approute.getServiceBooking(),
          arguments: {'garageId': garage.id},
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: AppColors.containerFillColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: garage.imageUrl.isNotEmpty
                    ? Image.network(
                        garage.imageUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.garage, size: 40),
                        ),
                      )
                    : Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.garage, size: 40),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      text: garage.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${garage.rating} (${garage.reviews})",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text("${garage.distance} "),
                        TranslatedText(
                          text: 'km',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? AppColors.greenOpacity
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TranslatedText(
                            text: statusLabel,
                            style: TextStyle(
                              color: isOpen ? Colors.green : Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            children: garage.tags
                                .map(
                                  (tag) => TranslatedText(
                                    text: tag,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(children: [const Icon(Icons.more_vert, size: 20)]),
            ],
          ),
        ),
      ),
    );
  }
}
