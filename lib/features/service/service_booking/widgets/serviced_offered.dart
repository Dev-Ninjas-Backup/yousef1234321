import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import '../controller/service_booking_controller.dart';

class ServiceOffered extends StatelessWidget {
  const ServiceOffered({super.key, required this.controller});
  final ServiceBookingController controller;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (controller.services.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Services Offered ---
          TranslatedText(
            text: "services_offered",
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
              final iconPath = item["icon"]?.toString();
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
                    if (iconPath != null && iconPath.isNotEmpty)
                      Image.asset(
                        iconPath,
                        height: 32,
                        width: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.build,
                              size: 32,
                              color: Colors.grey,
                            ),
                      )
                    else
                      const Icon(Icons.build, size: 32, color: Colors.grey),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TranslatedText(
                        text: item["title"]?.toString() ?? '',
                        textAlign: TextAlign.center,
                        style: getTextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
