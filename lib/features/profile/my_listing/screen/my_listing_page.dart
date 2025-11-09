import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/my_listing/conrtoller/listing_controller.dart';

import '../../../../core/common/widgets/action_button.dart';

class MyListingPage extends StatelessWidget {
  final controller = Get.put(ListingController());

  MyListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: "My Listing"),
              const SizedBox(height: 25),

              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final tabName = controller.tabs[index];
                    return Obx(() {
                      final isSelected = controller.selectedTab.value == index;
                      return GestureDetector(
                        onTap: () => controller.changeTab(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: Center(
                            child: Text(
                              tabName,
                              style: getTextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Listings
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.listings.length,
                    itemBuilder: (context, index) {
                      final item = controller.listings[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF000000).withValues(alpha: .05),
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item.image,
                                height: 112,
                                width: 112,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: getTextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.description,
                                    style: getTextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        "${item.price.toStringAsFixed(0)} AED",
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.star,
                                        size: 16,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        "${item.rating} (${item.reviews})",
                                        style: getTextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // ✅ Action Buttons
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    spacing: 2,

                                    children: [
                                      actionButton(
                                        "View details",
                                        color: Colors.blue.shade50,
                                        textColor: Colors.blue,
                                        onTap: () {},
                                      ),
                                      actionButton(
                                        "Re-post",
                                        borderColor: Colors.blue,
                                        textColor: Colors.blue,
                                        onTap: () {},
                                      ),
                                      actionButton(
                                        "Mark as sold",
                                        borderColor: Colors.red,
                                        textColor: Colors.red,
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}