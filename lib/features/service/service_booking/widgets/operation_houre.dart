import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_booking_controller.dart';

class OperationHour extends StatelessWidget {
  const OperationHour({super.key, required this.controller});
  final ServiceBookingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Operating Hours",
          style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sat – Thu: 8:00 AM – 8:00 PM",
              style: getTextStyle(fontSize: 12),
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: controller.isOpen.value
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.isOpen.value ? "Open" : "Closed",
                  style: getTextStyle(
                    fontSize: 12,
                    color: controller.isOpen.value ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Friday", style: getTextStyle(fontSize: 12)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Closed",
                style: getTextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
