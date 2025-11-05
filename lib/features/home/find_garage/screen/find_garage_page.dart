import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/home/find_garage/controller/find_charger_controller.dart';
import '../../../../core/common/widgets/custom_appbar.dart';
import '../wigets/slider_image.dart';

class FindGaragePage extends StatelessWidget {
  final FindChargerController controller = Get.put(FindChargerController());

  FindGaragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Search nearby garage"),
              const SizedBox(height: 24),

              // Search bar + filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search nearby garage",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: GestureDetector(
                        onTap: () {
                          controller.searchController.clear();
                        },
                        child: const Icon(Icons.clear,size: 20,)),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      controller.isDropdownVisible.value =
                          !controller.isDropdownVisible.value;
                    },
                    child: Image.asset(
                      Iconpath.filtericon,
                      height: 44,
                      width: 44,
                    ),
                  ),
                ],
              ),

              // Dropdown
              Obx(() {
                if (!controller.isDropdownVisible.value) {
                  return const SizedBox();
                }
                return 
                
                
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(0, 4),
                        color: Color(0xFF000000).withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: Column(
                    children: controller.items.map((item) {
                      bool isSelected = controller.selectedItem.value == item;
                      return GestureDetector(
                        onTap: () => controller.selectedItem.value = item,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFFE8F1FD)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item,
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );



              }),

              const SizedBox(height: 24),
              Image.asset("assets/images/findGarageMap.png"),
              const SizedBox(height: 24),

              // Horizontal image slider
              SliderImge(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

