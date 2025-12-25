import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/service/rate_service/screen/service_review_scree.dart'
    show ServiceReviewScreen;
import 'package:yousef1234321/features/service/service_booking/controller/service_booking_controller.dart';
import '../../../../core/common/constants/app_colors.dart';
import '../widgets/operation_houre.dart';
import '../widgets/service_booking_middle_section.dart';
import '../widgets/service_booking_upper_section.dart';
import '../widgets/serviced_offered.dart';

class ServiceBooking extends StatelessWidget {
  final controller = Get.put(ServiceBookingController());
  ServiceBooking({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  "Failed to load garage details",
                  style: getTextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchGarageDetails(),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceBookingUpperSection(controller: controller),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceBookingMiddleSection(controller: controller),
                    SizedBox(height: 24),
                    ServiceOffered(controller: controller),
                    SizedBox(height: 24),

                    OperationHour(controller: controller),

                    const SizedBox(height: 24),

                    // --- Location ---
                    Text(
                      "Location & Map",
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Text(
                            controller.garageDetail.value?.formattedAddress ??
                                controller.garageDetail.value?.address ??
                                "Al Qusais Industrial Area 2, Dubai, UAE",
                            style: getTextStyle(fontSize: 12),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "See location",
                            style: getTextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    //map
                    Image.asset("assets/images/image 2.png"),
                    SizedBox(height: 24),

                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 14,
                          ),
                        ),
                        onPressed: () {
                          Get.to(ServiceReviewScreen());
                        },
                        icon: const Icon(
                          Icons.mode_edit_outline_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Write review",
                          style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
