import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/home/garage_list/controller/garage_list_controller.dart';
import 'package:yousef1234321/features/home/home_page/widget/garage_card.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

class GarageListScreen extends StatelessWidget {
  const GarageListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GarageListController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 52),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomAppBar(title: "All Garages".tr),
          ),
          const SizedBox(height: 16),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearch,
              decoration: InputDecoration(
                hintText: "Search garages...".tr,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filters Row
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // City Filter
                Obx(
                  () => FilterChip(
                    label: TranslatedText(
                      text: controller.selectedCity.value ?? 'City',
                      style: TextStyle(
                        color: controller.selectedCity.value != null
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    selected: controller.selectedCity.value != null,
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color(0xFFF9FAFB),
                    onSelected: (_) => _showCityPicker(context, controller),
                  ),
                ),
                const SizedBox(width: 8),

                // // Emirate Filter
                Obx(
                  () => FilterChip(
                    label: TranslatedText(
                      text: controller.selectedEmirate.value ?? 'Emirate',
                      style: TextStyle(
                        color: controller.selectedEmirate.value != null
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    selected: controller.selectedEmirate.value != null,
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color(0xFFF9FAFB),
                    onSelected: (_) => _showEmiratePicker(context, controller),
                  ),
                ),
                const SizedBox(width: 8),

                // // Service Filter
                Obx(
                  () => FilterChip(
                    label: TranslatedText(
                      text: controller.selectedService.value ?? 'Service',
                      style: TextStyle(
                        color: controller.selectedService.value != null
                            ? Colors.white
                            : Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                    selected: controller.selectedService.value != null,
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color(0xFFF9FAFB),
                    onSelected: (_) => _showServicePicker(context, controller),
                  ),
                ),
                const SizedBox(width: 8),

                // Status Filter
                Obx(
                  () => FilterChip(
                    label: TranslatedText(
                      text: controller.selectedStatus.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    selected: true,
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: const Color(0xFFF9FAFB),
                    onSelected: (_) => _showStatusPicker(context, controller),
                  ),
                ),
                const SizedBox(width: 8),

                // Clear Filters
                Obx(() {
                  final hasFilters =
                      controller.selectedCity.value != null ||
                      controller.selectedEmirate.value != null ||
                      controller.selectedService.value != null ||
                      controller.searchController.text.isNotEmpty;

                  if (!hasFilters) return const SizedBox.shrink();

                  return ActionChip(
                    label: TranslatedText(
                      text: 'Clear',
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),

                    backgroundColor: Colors.red.withValues(alpha: 0.1),

                    onPressed: controller.clearFilters,
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Garage List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.garages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.garages.isEmpty) {
                return Center(
                  child: TranslatedText(
                    text: 'No garages found',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount:
                    controller.garages.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.garages.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final garage = controller.garages[index];
                  return GarageCard(garage: garage);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context, GarageListController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              text: 'Select City',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: TranslatedText(text: 'All'),
              onTap: () {
                controller.selectedCity.value = null;
                controller.applyFilters();
                Navigator.pop(context);
              },
            ),
            ...controller.cities.map(
              (city) => ListTile(
                title: TranslatedText(text: city),
                onTap: () {
                  controller.selectedCity.value = city;
                  controller.applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmiratePicker(
    BuildContext context,
    GarageListController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              text: 'Select Emirate',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: TranslatedText(text: 'All'),
              onTap: () {
                controller.selectedEmirate.value = null;
                controller.applyFilters();
                Navigator.pop(context);
              },
            ),
            ...controller.emirates.map(
              (emirate) => ListTile(
                title: TranslatedText(text: emirate),
                onTap: () {
                  controller.selectedEmirate.value = emirate;
                  controller.applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showServicePicker(
    BuildContext context,
    GarageListController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              text: 'Select Service',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView(
                  children: [
                    ListTile(
                      title: TranslatedText(text: 'All'),
                      onTap: () {
                        controller.selectedService.value = null;
                        controller.applyFilters();
                        Navigator.pop(context);
                      },
                    ),
                    ...controller.serviceTypes.map(
                      (service) => ListTile(
                        title: TranslatedText(text: service),
                        onTap: () {
                          controller.selectedService.value = service;
                          controller.applyFilters();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusPicker(
    BuildContext context,
    GarageListController controller,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TranslatedText(
              text: 'Select Status',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...controller.statuses.map(
              (status) => ListTile(
                title: TranslatedText(text: status),
                onTap: () {
                  controller.selectedStatus.value = status;
                  controller.applyFilters();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
