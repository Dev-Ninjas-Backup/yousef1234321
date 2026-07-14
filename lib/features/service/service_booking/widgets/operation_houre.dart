import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../../../../core/common/widgets/translated_text.dart';
import '../controller/service_booking_controller.dart';

class OperationHour extends StatefulWidget {
  const OperationHour({super.key, required this.controller});
  final ServiceBookingController controller;

  @override
  State<OperationHour> createState() => _OperationHourState();
}

class _OperationHourState extends State<OperationHour> {
  bool _isExpanded = false;

  Map<String, String>? _parseHoursJson(String hoursStr) {
    if (hoursStr.isEmpty) return null;
    try {
      final decoded = jsonDecode(hoursStr);
      if (decoded is Map) {
        return decoded.map((k, v) => MapEntry(k.toString(), v.toString()));
      }
    } catch (_) {}
    return null;
  }

  String? _getHoursForToday(dynamic garage) {
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
    return hoursString.isNotEmpty ? hoursString : null;
  }

  Map<String, dynamic> _getOpenStatus() {
    final garage = widget.controller.garageDetail.value;
    if (garage == null) return {'isOpen': false, 'label': 'closed'};

    final hoursString = _getHoursForToday(garage);
    if (hoursString == null || hoursString.isEmpty || hoursString.toLowerCase() == 'closed') {
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

      // Handle normal and overnight ranges correctly
      bool isOpen;
      if (closeMinutes > openMinutes) {
        // same-day range (e.g. 8:00 AM - 8:00 PM)
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

  List<String> _getFormattedHoursList(dynamic garage) {
    if (garage == null) return [];

    final List<String> lines = [];

    // Try parsing weekdaysHours as JSON
    final weekdaysParsed = _parseHoursJson(garage.weekdaysHours);
    // Try parsing weekendsHours as JSON
    final weekendsParsed = _parseHoursJson(garage.weekendsHours);

    if (weekdaysParsed != null || weekendsParsed != null) {
      final mergedMap = <String, String>{};
      if (weekdaysParsed != null) {
        mergedMap.addAll(weekdaysParsed);
      }
      if (weekendsParsed != null) {
        mergedMap.addAll(weekendsParsed);
      }

      // Show all days starting with the current day (latest day first)
      final now = DateTime.now();
      final currentDay = now.weekday; // 1 = Monday, 7 = Sunday
      final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final startIndex = currentDay - 1;
      
      final List<String> daysOrder = [];
      for (int i = 0; i < 7; i++) {
        daysOrder.add(daysOfWeek[(startIndex + i) % 7]);
      }

      for (final day in daysOrder) {
        final key = mergedMap.keys.firstWhere(
          (k) => k.toLowerCase() == day.toLowerCase(),
          orElse: () => '',
        );
        final hours = key.isNotEmpty ? mergedMap[key] : null;

        if (hours == null || hours.isEmpty || hours.toLowerCase() == 'closed') {
          lines.add("$day: Closed");
        } else {
          lines.add("$day: $hours");
        }
      }
    } else {
      // Fallback if they are not JSON
      if (garage.weekdaysHours.isNotEmpty) {
        lines.add("Weekdays: ${garage.weekdaysHours}");
      }
      if (garage.weekendsHours.isNotEmpty && garage.weekendsHours != 'JSON_SCHEDULE') {
        lines.add("Weekends: ${garage.weekendsHours}");
      }
    }

    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final garage = widget.controller.garageDetail.value;
    final openStatus = _getOpenStatus();
    final isOpen = openStatus['isOpen'] as bool;
    final statusLabel = openStatus['label'] as String;
    final formattedHours = _getFormattedHoursList(garage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TranslatedText(
          text: "operating_hours",
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collapsed Header (Tap to expand/collapse)
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: Colors.grey.shade600),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (formattedHours.isEmpty) {
                                  return TranslatedText(
                                    text: "default_weekdays_hours",
                                    style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  );
                                }
                                
                                final firstLine = formattedHours.first;
                                final parts = firstLine.split(':');
                                final dayName = parts.first;
                                final hoursVal = parts.skip(1).join(':');
                                
                                return Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    TranslatedText(
                                      text: dayName,
                                      style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      ":$hoursVal",
                                      style: getTextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "(Today)",
                                      style: getTextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isOpen ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TranslatedText(
                            text: statusLabel,
                            style: getTextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isOpen ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Expanded Section (Show other days)
              if (_isExpanded && formattedHours.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(),
                ),
                ...formattedHours.map((line) {
                  final isToday = line == formattedHours.first;
                  final parts = line.split(':');
                  final dayName = parts.first;
                  final hoursVal = parts.skip(1).join(':');
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 26),
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              TranslatedText(
                                text: dayName,
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                                  color: isToday ? Colors.black : Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                ":$hoursVal",
                                style: getTextStyle(
                                  fontSize: 13,
                                  fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                                  color: isToday ? Colors.black : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isToday)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TranslatedText(
                              text: "today",
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
