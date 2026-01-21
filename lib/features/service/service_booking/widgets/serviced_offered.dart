import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_booking_controller.dart';

class ServiceOffered extends StatelessWidget {
  const ServiceOffered({super.key, required this.controller});
  final ServiceBookingController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.services.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Services Offered ---
          Text(
            "services_offered".tr,
            style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = controller.services[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFF3F4F6)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                      color: Color(0xFF000000).withValues(alpha: 0.05),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item["icon"]?.toString() ?? '',
                      height: 32,
                      width: 32,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (item["title"]?.toString() ?? '').tr,
                      textAlign: TextAlign.center,
                      style: getTextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
