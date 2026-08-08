import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/my_listing/conrtoller/listing_controller.dart';
import 'package:yousef1234321/features/profile/my_listing/model/product_model.dart';
import 'package:yousef1234321/routes/app_route.dart';

class MyListingPage extends GetView<ListingController> {
  const MyListingPage({super.key});

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
              CustomAppBar(title: "my_listing"),
              const SizedBox(height: 20),

              // Filter Tabs
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
                              tabName.tr,
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

              // Listings List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.hasError.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'failed_to_load_listings'.tr,
                            style: getTextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => controller.fetchMyListings(),
                            child: Text('retry'.tr),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'no_listings_yet'.tr,
                            style: getTextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.fetchMyListings(),
                    child: ListView.builder(
                      itemCount: controller.products.length,
                      itemBuilder: (context, index) {
                        final item = controller.products[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Approute.brakePadsScreen,
                              arguments: {
                                'productId': item.id,
                                'isMyListing': true,
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .05),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildImage(item.mainImage),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.partName,
                                        style: getTextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item.brand != null &&
                                          item.brand!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'Brand: ${item.brand}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item.price.toStringAsFixed(0)} AED",
                                        style: getTextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Badges (Status & Promoted)
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          _buildStatusBadge(item),
                                          if (item.isPromoted && !item.isExpired)
                                            _buildPromotedBadge(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds Status Badge (APPROVED, PENDING, REJECTED, DRAFT, EXPIRED)
  Widget _buildStatusBadge(ProductModel item) {
    if (item.isExpired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history, size: 12, color: Colors.red.shade700),
            const SizedBox(width: 4),
            Text(
              'EXPIRED',
              style: TextStyle(
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    switch (item.status) {
      case 'APPROVED':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 12, color: Colors.green.shade700),
              const SizedBox(width: 4),
              Text(
                'APPROVED',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      case 'PENDING':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.amber.shade800),
              const SizedBox(width: 4),
              Text(
                'PENDING',
                style: TextStyle(
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      case 'REJECTED':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.cancel_outlined, size: 12, color: Colors.red.shade700),
              const SizedBox(width: 4),
              Text(
                'REJECTED',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      case 'DRAFT':
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.drafts_outlined, size: 12, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(
                item.status,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
    }
  }

  /// Builds Promoted Star Badge
  Widget _buildPromotedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFF59E0B)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 12, color: Color(0xFFD97706)),
          SizedBox(width: 4),
          Text(
            'PROMOTED',
            style: TextStyle(
              color: Color(0xFFB45309),
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    final isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return isNetworkImage
        ? Image.network(
            imagePath,
            height: 90,
            width: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 90,
                width: 90,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          )
        : Image.asset(
            imagePath,
            height: 90,
            width: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 90,
                width: 90,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported),
              );
            },
          );
  }
}
