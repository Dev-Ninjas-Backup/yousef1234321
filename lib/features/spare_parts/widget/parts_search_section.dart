import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/service/translation_service.dart';
import '../controller/spare_parts_controller.dart';

class PartsSearchSection extends StatelessWidget {
  PartsSearchSection({super.key});

  final SparePartsController controller = Get.find<SparePartsController>();

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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text: "find_car_services_near_you",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TranslatedText(
            text: "emergency_repairs_subtitle",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                Row(
                  children: [
                    // Search Keyword Input
                    Expanded(
                      child: FutureBuilder<String>(
                        future: Get.find<TranslationService>().translate(
                          _getEnglishText("search"),
                        ),
                        initialData: "Search",
                        builder: (context, snapshot) {
                          return TextField(
                            controller: controller.searchInputController,
                            onChanged: (v) =>
                                controller.selectedModel.value = v,
                            decoration: InputDecoration(
                              hintText: snapshot.data,
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
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Category Dropdown Selection
                    Expanded(
                      child: Obx(() {
                        final categoryNames = controller.categories
                            .map((c) => c['name']?.toString() ?? '')
                            .where((s) => s.isNotEmpty)
                            .toList();

                        final items = ["select_category", ...categoryNames];

                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          initialValue: (controller.selectedCategory.value != null &&
                                  items.contains(
                                    controller.selectedCategory.value,
                                  ))
                              ? controller.selectedCategory.value
                              : "select_category",
                          items: items
                              .map(
                                (service) => DropdownMenuItem(
                                  value: service,
                                  child: TranslatedText(
                                    text: service,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == "select_category") {
                              controller.selectedCategory.value = null;
                            } else {
                              controller.selectedCategory.value = value;
                            }
                          },
                          hint: TranslatedText(text: "category_type"),
                          decoration: InputDecoration(
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

                // Search Action Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => controller.performSearch(),
                  child: TranslatedText(text: "search_parts"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
