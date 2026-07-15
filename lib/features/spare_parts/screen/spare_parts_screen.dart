// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/features/spare_parts/controller/products_controller.dart';
import 'package:yousef1234321/features/spare_parts/controller/spare_parts_controller.dart';
import 'package:yousef1234321/features/spare_parts/widget/category_item.dart';
import 'package:yousef1234321/features/spare_parts/widget/part_item.dart';
import 'package:yousef1234321/features/spare_parts/widget/parts_search_section.dart';
import 'package:yousef1234321/routes/app_route.dart';

import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';

import '../../../core/common/style/global_text_style.dart';

class SparePartsScreen extends StatelessWidget {
  SparePartsScreen({super.key});

  // Ensure we only run the initial fetch once per app lifecycle to avoid repeated network calls
  static bool _initialized = false;

  final SparePartsController controller = Get.put(SparePartsController());

  // Helper to get English text for a key to send to TranslationService
  String _getEnglishText(String key) {
    final englishMap = Get.translations['en_US'];
    if (englishMap != null && englishMap.containsKey(key)) {
      return englishMap[key]!;
    }
    return key;
  }

  @override
  Widget build(BuildContext context) {
    // Run initial fetch once (guarded) to avoid registering multiple postFrame callbacks
    if (!SparePartsScreen._initialized) {
      SparePartsScreen._initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final allPartsCtrl = Get.put(ProductsController(), tag: 'allParts');
        if (allPartsCtrl.products.isEmpty && !allPartsCtrl.isLoading.value) {
          allPartsCtrl.fetchProducts(page: 1, limit: 10);
        }
        final todaysDealsCtrl = Get.put(
          ProductsController(),
          tag: 'todaysDeals',
        );
        if (todaysDealsCtrl.products.isEmpty &&
            !todaysDealsCtrl.isLoading.value) {
          todaysDealsCtrl.fetchProducts(page: 1, limit: 10);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(Iconpath.carHomeIcon, height: 37, width: 37),
                    SizedBox(width: 8),
                    TranslatedText(
                      text: 'sayara_hub',
                      style: getTextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.1),
                      child: Image.asset(Iconpath.notification, scale: 2),
                    ),
                    SizedBox(width: 12),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg",
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            PartsSearchSection(),
            const SizedBox(height: 16),
            // Category section - Single row horizontally scrollable
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CategoryItem(
                      icon: cat['icon'] as IconData,
                      title: cat['name'] as String,
                      color: controller.getRandomColor(),
                      onTap: () async {
                        // extract category name
                        final cname = (cat['name'] ?? 'category').toString();

                        final productsCtrl = Get.put(
                          ProductsController(),
                          tag: 'productsList',
                        );
                        await productsCtrl.fetchProducts(
                          page: 1,
                          limit: 20,
                          category: cname,
                        );

                        _openProductListScreen(cname, productsCtrl);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Blue ad section
            Stack(
              children: [
                Image.asset(Imagepath.addBg),

                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),

                      TranslatedText(
                        text: 'have_spare_parts_to_sell',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TranslatedText(
                        text: 'list_your_car_parts',
                        style: TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Get.toNamed(Approute.partsDetailsScreen);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TranslatedText(
                              text: 'sell_now',
                              style: TextStyle(color: Colors.blue),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, color: Colors.blue),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // All Parts
            sectionHeader("all_parts"),

            const SizedBox(height: 8),
            //_sectionCard("all_parts"),
            const SizedBox(height: 10),
            // partsList already uses Obx internally; avoid wrapping it in another Obx
            partsList(Get.put(ProductsController(), tag: 'allParts')),

            const SizedBox(height: 20),

            // Today's Deals
            sectionHeader("todays_deals"),
            const SizedBox(height: 8),
            //_sectionCard("todays_deals"),
            const SizedBox(height: 10),
            // partsList already uses Obx internally; avoid wrapping it in another Obx
            partsList(Get.put(ProductsController(), tag: 'todaysDeals')),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String titleKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TranslatedText(
          text: titleKey,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        TextButton(
          onPressed: () async {
            // Navigate to products list page with API call (page=1, limit=10)
            // Create ProductsController and fetch products
            final productsCtrl = Get.put(
              ProductsController(),
              tag: 'productsList',
            );
            await productsCtrl.fetchProducts(page: 1, limit: 10);

            _openProductListScreen('all_spare_parts', productsCtrl);
          },
          child: TranslatedText(text: "see_all"),
        ),
      ],
    );
  }

  Widget partsList(ProductsController productsCtrl) {
    return SizedBox(
      height: 215,
      child: Obx(() {
        // loading state
        if (productsCtrl.isLoading.value && productsCtrl.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // show network/server error if present
        final err = productsCtrl.error.value;
        if (err != null && err.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TranslatedText(
                  text: err,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    await productsCtrl.fetchProducts(
                      page: 1,
                      limit: productsCtrl.limit.value,
                      categoryId: productsCtrl.currentCategoryId.value,
                      search: productsCtrl.currentSearch.value,
                    );
                  },
                  child: TranslatedText(text: 'retry'),
                ),
              ],
            ),
          );
        }

        // empty list (no items)
        if (productsCtrl.products.isEmpty) {
          return Center(child: TranslatedText(text: 'no_products_available'));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: productsCtrl.products.length,
          itemBuilder: (context, index) {
            final item = productsCtrl.products[index];
            // prefer profilePhoto (normalized) then first photos entry, then placeholder
            final imageUrl =
                (item is Map &&
                    item['profilePhoto'] != null &&
                    item['profilePhoto'].toString().isNotEmpty)
                ? item['profilePhoto'].toString()
                : (item is Map &&
                      item['photos'] is List &&
                      item['photos'].isNotEmpty)
                ? item['photos'][0].toString()
                : 'https://via.placeholder.com/150'; // fallback placeholder URL
            final name = (item is Map && item['partName'] != null)
                ? item['partName'].toString()
                : 'N/A';
            final desc = (item is Map && item['description'] != null)
                ? item['description'].toString()
                : 'N/A';
            final price = (item is Map && item['price'] != null)
                ? double.parse(item['price'].toString())
                : 0.0;
            final rating = (item is Map && item['rating'] != null)
                ? double.parse(item['rating'].toString())
                : 0.0; // Assuming rating might not be in the API response yet

            return GestureDetector(
              onTap: () {
                // extract id robustly and navigate to details
                String? id;
                if (item is Map) {
                  if (item['id'] != null)
                    id = item['id'].toString();
                  else if (item['data'] is Map && item['data']['id'] != null)
                    id = item['data']['id'].toString();
                }
                if (id != null) {
                  Get.toNamed(Approute.getBrakePadsScreen(), arguments: id);
                }
              },
              child: PartItem(
                image: imageUrl,
                name: name,
                desc: desc,
                price: price,
                rating: rating,
              ),
            );
          },
        );
      }),
    );
  }

  // Small card shown above parts lists with quick CTA
  // Widget _sectionCard(String titleKey) {
  //   return GestureDetector(
  //     onTap: () async {
  //       // open the same 'See All' full list
  //       final productsCtrl = Get.put(ProductsController(), tag: 'productsList');
  //       await productsCtrl.fetchProducts(page: 1, limit: 10);
  //       _openProductListScreen(titleKey, productsCtrl);
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 0),
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(12),
  //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 64,
  //             height: 64,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(10),
  //               image: DecorationImage(
  //                 image: AssetImage(Imagepath.image2),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(width: 12),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TranslatedText(
  //                   text: _getEnglishText(
  //                     'explore',
  //                   ).replaceAll('@title', _getEnglishText(titleKey)),
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 6),
  //                 TranslatedText(
  //                   text: 'find_best_spare_parts',
  //                   style: TextStyle(color: Colors.grey, fontSize: 12),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final productsCtrl = Get.put(
  //                 ProductsController(),
  //                 tag: 'productsList',
  //               );
  //               await productsCtrl.fetchProducts(page: 1, limit: 10);
  //               _openProductListScreen(titleKey, productsCtrl);
  //             },
  //             child: TranslatedText(text: 'see_all'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _openProductListScreen(String title, ProductsController productsCtrl) {
    Get.to(
      () => Scaffold(
        backgroundColor: AppColors.containerFillColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 16,
          title: CustomAppBar(title: title),
        ),
        body: Obx(() {
          if (productsCtrl.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  : (p is Map && p['photos'] is List && p['photos'].isNotEmpty
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
                    if (p['id'] != null)
                      id = p['id'].toString();
                    else if (p['data'] is Map && p['data']['id'] != null)
                      id = p['data']['id'].toString();
                  }
                  if (id != null) {
                    Get.toNamed(Approute.getBrakePadsScreen(), arguments: id);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
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
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return const Center(
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.primaryColor),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              // Price and Action Button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TranslatedText(
                                    text: _getEnglishText(
                                      'price',
                                    ).replaceAll('@price', price),
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
      ),
    );
  }
}
