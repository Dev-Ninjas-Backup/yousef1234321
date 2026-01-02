import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/routes/app_route.dart';
import '../controller/service_controller.dart';
import '../model/garage_model.dart';
import '../widgets/search_and_filter.dart';

class FindService extends StatelessWidget {
  final ServiceController controller = Get.put(ServiceController());

  FindService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 52, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppBar(title: "find_service"),
            const SizedBox(height: 32),
            SearchAndFilter(controller: controller),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'nearby_garages'.tr,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     // Optional: Navigate to full garage list
                //   },
                //   child: Text(
                //     "View All",
                //     style: getTextStyle(
                //       color: AppColors.splashButtonColor,
                //       fontSize: 14,
                //       fontWeight: FontWeight.w400,
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    // Optional: Navigate to full garage list
                  },
                  child: Text(
                    'view_all'.tr,
                    style: getTextStyle(
                      color: AppColors.splashButtonColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Expanded list for garages only
            Expanded(
              child: Obx(() {
                if (controller.isLoadingNearby.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.garages.isEmpty) {
                  return Center(
                    child: Text(
                      'no_garages_available'.tr,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                final List<GarageModel> list = controller.garages.toList(
                  growable: false,
                );

                return ListView.builder(
                  itemCount: list.length,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (_, index) {
                    final g = list[index];
                    final String name = g.name;
                    final String? profileImage = g.profileImage;
                    final String distance = g.distance?.toString() ?? '';

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          Approute.getServiceBooking(),
                          arguments: {'garageId': g.id},
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image:
                                      (profileImage != null &&
                                          profileImage.isNotEmpty)
                                      ? NetworkImage(profileImage)
                                      : AssetImage(Imagepath.onboarding1)
                                            as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        name,
                                        style: getTextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Color(0xFF2ECC71),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${g.averageRating ?? 0} (${g.totalReviews ?? 0})",
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: AppColors.subTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: AppColors.subTextColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'distance_km'.tr.replaceAll(
                                          '@distance',
                                          distance,
                                        ),
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: AppColors.subTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          color: g.isOpenNow == true
                                              ? const Color(0xFFDCFCE7)
                                              : const Color(0xFFF3F4F6),
                                        ),
                                        child: Text(
                                          g.isOpenNow == true
                                              ? 'open'.tr
                                              : 'closed'.tr,
                                          style: getTextStyle(
                                            fontSize: 12,
                                            color: g.isOpenNow == true
                                                ? const Color(0xFF2ECC71)
                                                : AppColors.subTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),
                                  // Open / Closed badge for this garage
                                  Row(children: [
                                      
                                    ],
                                  ),

                                  const SizedBox(height: 6),
                                  Text(
                                    g.address ?? '',
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: AppColors.subTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
