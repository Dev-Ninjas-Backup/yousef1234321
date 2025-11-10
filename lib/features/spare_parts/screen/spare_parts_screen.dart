import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/features/spare_parts/controller/spare_parts_controller.dart';
import 'package:yousef1234321/features/spare_parts/widget/category_item.dart';
import 'package:yousef1234321/features/spare_parts/widget/part_item.dart';
import 'package:yousef1234321/features/spare_parts/widget/parts_search_section.dart';
import 'package:yousef1234321/routes/app_route.dart';

import '../../../core/common/style/global_text_style.dart';

class SparePartsScreen extends StatelessWidget {
  SparePartsScreen({super.key});

  final SparePartsController controller = Get.put(SparePartsController());

  @override
  Widget build(BuildContext context) {
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
                    Text(
                      "SayaraHub",
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
            // Category section
            SizedBox(
              height: 160,
              width: double.maxFinite,
              child: Align(
                alignment: Alignment.center,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 9,
                  ),

                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final cat = controller.categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),

                      child: CategoryItem(
                        icon: cat['icon'] as IconData,
                        title: cat['name'] as String,
                        color: controller.getRandomColor(),
                      ),
                    );
                  },
                ),
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

                      const Text(
                        "Have Spare Parts to Sell?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "List your car parts in just a few steps and connect with customers directly from the app.",
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Sell Now",
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
            sectionHeader("All Parts"),

            const SizedBox(height: 10),
            partsList(),

            const SizedBox(height: 20),

            // Today's Deals
            sectionHeader("Today's Deals"),
            const SizedBox(height: 10),
            partsList(),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            
          },
          child: const Text("See All"),
        ),
      ],
    );
  }

  Widget partsList() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.allParts.length,
        itemBuilder: (context, index) {
          final item = controller.allParts[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Approute.brakePadsScreen);
            },

            child: PartItem(
              image: item['image']! as String,
              name: item['name']! as String,
              desc: item['desc']! as String,
              price: item['price']! as double,
              rating: item['rating']! as double,
            ),
          );
        },
      ),
    );
  }
}
