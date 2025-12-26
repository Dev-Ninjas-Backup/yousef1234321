import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/parts_details/controller/parts_details_controller.dart';

class PromoteListingView extends StatelessWidget {
  PromoteListingView({super.key});

  final PartsDetailsController controller =
      Get.put(PartsDetailsController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () =>
            controller.togglePromotion(!controller.isPromoted.value),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8D6), // light yellow
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFFFE08A),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: controller.isPromoted.value,
                onChanged: (value) =>
                    controller.togglePromotion(value ?? false),
                activeColor: Colors.orange,
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.local_offer_outlined,
                          size: 18,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Promote This Listing - 20 AED',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Get better visibility! Your listing will appear in the '
                      'promotional carousel on the homepage and be highlighted '
                      'in search results.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
