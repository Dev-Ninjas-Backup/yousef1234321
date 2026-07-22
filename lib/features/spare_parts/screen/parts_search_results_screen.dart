import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/features/spare_parts/controller/products_controller.dart';
import 'package:yousef1234321/routes/app_route.dart';

class PartsSearchResultsScreen extends StatelessWidget {
  const PartsSearchResultsScreen({super.key});

  // Helper to get English text for a key to send to TranslationService if needed
  String _getEnglishText(String key) {
    final englishMap = Get.translations['en_US'];
    if (englishMap != null && englishMap.containsKey(key)) {
      return englishMap[key]!;
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    final productsCtrl = Get.find<ProductsController>(tag: 'productsList');

    return Scaffold(
      backgroundColor: AppColors.containerFillColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: const CustomAppBar(title: 'search_results'),
      ),
      body: Obx(() {
        if (productsCtrl.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (productsCtrl.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                TranslatedText(
                  text: 'no_products',
                  style: getTextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          itemCount: productsCtrl.products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, idx) {
            final p = productsCtrl.products[idx];
            final name = (p is Map && p['partName'] != null)
                ? p['partName'].toString()
                : 'product ${idx + 1}';
            final price = (p is Map && p['price'] != null)
                ? p['price'].toString()
                : '-';
            final photo = (p is Map && p['profilePhoto'] != null)
                ? p['profilePhoto'].toString()
                : (p is Map &&
                        p['photos'] is List &&
                        p['photos'].isNotEmpty
                    ? p['photos'][0].toString()
                    : null);
            final desc = (p is Map && p['description'] != null)
                ? p['description'].toString()
                : '';
            final rating = (p is Map && p['rating'] != null)
                ? double.tryParse(p['rating'].toString()) ?? 0.0
                : 0.0;

            return GestureDetector(
              onTap: () {
                String? id;
                if (p is Map) {
                  if (p['id'] != null) {
                    id = p['id'].toString();
                  } else if (p['data'] is Map && p['data']['id'] != null) {
                    id = p['data']['id'].toString();
                  }
                }
                if (id != null) {
                  Get.toNamed(
                    Approute.getBrakePadsScreen(),
                    arguments: id,
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.04,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left - Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 90,
                          height: 90,
                          color: AppColors.containerFillColor,
                          child: photo != null
                              ? Image.network(
                                  photo,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Image.asset(
                                      Iconpath.carHomeIcon,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Image.asset(
                                    Iconpath.carHomeIcon,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right - Content Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Optional Rating Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TranslatedText(
                                    text: name,
                                    style: getTextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                if (rating > 0)
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        rating.toString(),
                                        style: getTextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Description
                            if (desc.isNotEmpty && desc != 'N/A')
                              TranslatedText(
                                text: desc,
                                style: getTextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.subTextColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            const SizedBox(height: 12),
                            // Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TranslatedText(
                                  text:
                                      "${_getEnglishText('price').replaceAll('@price', price)} AED",
                                  style: getTextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
