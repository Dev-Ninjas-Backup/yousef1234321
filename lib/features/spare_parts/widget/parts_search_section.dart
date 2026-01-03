import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/spare_parts/controller/products_controller.dart';
import 'package:yousef1234321/routes/app_route.dart';

import '../controller/spare_parts_controller.dart';

class PartsSearchSection extends StatelessWidget {
  PartsSearchSection({super.key});

  final SparePartsController controller = Get.find<SparePartsController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "find_car_services_near_you".tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "emergency_repairs_subtitle".tr,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Replaced Row(spacing: ...) with a proper layout and API-backed dropdown
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (v) => controller.selectedModel.value = v,
                        decoration: InputDecoration(
                          hintText: "search".tr,
                          hintStyle: getTextStyle(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Obx(() {
                        // Build a simple list of names from the API categories
                        final categoryNames = controller.categories
                            .map((c) => c['name']?.toString() ?? '')
                            .where((s) => s.isNotEmpty)
                            .toList();

                        final items = ["select_category".tr, ...categoryNames];

                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          // if a category is already selected use it, otherwise pick "Select Category"
                          initialValue:
                              (controller.selectedCategory.value != null &&
                                  items.contains(
                                    controller.selectedCategory.value,
                                  ))
                              ? controller.selectedCategory.value
                              : "select_category".tr,
                          items: items
                              .map(
                                (service) => DropdownMenuItem(
                                  value: service,
                                  child: Text(
                                    service,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == "select_category".tr) {
                              controller.selectedCategory.value = null;
                            } else {
                              controller.selectedCategory.value = value;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "category_type".tr,
                            hintStyle: getTextStyle(),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFE5E7EB),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    final searchText = controller.selectedModel.value ?? '';
                    final category = controller.selectedCategory.value;

                    if (searchText.trim().isEmpty &&
                        (category == null || category.isEmpty)) {
                      Get.snackbar(
                        "selection_required".tr,
                        "enter_search_term_or_category".tr,
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    final productsCtrl = Get.put(
                      ProductsController(),
                      tag: 'productsList',
                    );

                    // find category id by name from spare parts controller
                    final selectedName = controller.selectedCategory.value;
                    String? catId;
                    if (selectedName != null && selectedName.isNotEmpty) {
                      final match = controller.categories.firstWhere(
                        (c) => (c['name']?.toString() ?? '') == selectedName,
                        orElse: () => {},
                      );
                      if (match.isNotEmpty) catId = match['id']?.toString();
                    }

                    // Use text from TextField if needed; for now will use selectedModel as search term
                    final searchTerm = controller.selectedModel.value;

                    await productsCtrl.fetchProducts(
                      page: 1,
                      limit: 20,
                      categoryId: catId,
                      search: searchTerm,
                    );

                    Get.to(
                      () => Scaffold(
                        appBar: AppBar(title: Text('search_results'.tr)),
                        body: Obx(() {
                          if (productsCtrl.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (productsCtrl.products.isEmpty) {
                            return Center(child: Text('no_products'.tr));
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: productsCtrl.products.length,
                            itemBuilder: (_, idx) {
                              final p = productsCtrl.products[idx];
                              final name = (p is Map && p['partName'] != null)
                                  ? p['partName'].toString()
                                  : '${'product'.tr} ${idx + 1}';
                              final price = (p is Map && p['price'] != null)
                                  ? p['price'].toString()
                                  : '-';
                              final photo =
                                  (p is Map && p['profilePhoto'] != null)
                                  ? p['profilePhoto'].toString()
                                  : (p is Map &&
                                            p['photos'] is List &&
                                            p['photos'].isNotEmpty
                                        ? p['photos'][0].toString()
                                        : null);

                              return ListTile(
                                leading: photo != null
                                    ? Image.network(
                                        photo,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                              Iconpath.carHomeIcon,
                                              width: 56,
                                              height: 56,
                                            ),
                                      )
                                    : Image.asset(
                                        Iconpath.carHomeIcon,
                                        width: 56,
                                        height: 56,
                                      ),
                                title: Text(name),
                                subtitle: Text(
                                  'price'.tr.replaceAll('@price', price),
                                ),
                                onTap: () {
                                  String? id;
                                  if (p is Map) {
                                    if (p['id'] != null) {
                                      id = p['id'].toString();
                                    } else if (p['data'] is Map &&
                                        p['data']['id'] != null) {
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
                              );
                            },
                          );
                        }),
                      ),
                    );
                  },
                  child: Text("search_parts".tr),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
