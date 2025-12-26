import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/widget/garage_card.dart';
import 'package:yousef1234321/features/home/home_page/widget/search_section.dart';
import 'package:yousef1234321/features/home/home_page/widget/service_chip.dart';
import 'package:yousef1234321/routes/app_route.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SearchSection(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.red.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Emergency Service\n24/7 Available",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Search Now",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Popular Services",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Column(
              spacing: 10,
              children: [
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ServiceChip(
                        label: "AC Repair",
                        icon: Iconpath.acIcon,
                      ),
                    ),
                    Expanded(
                      child: ServiceChip(
                        label: "Battery",
                        icon: Iconpath.batterryIcon,
                      ),
                    ),
                    Expanded(
                      child: ServiceChip(
                        label: "Engine",
                        icon: Iconpath.engineIcon,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    Expanded(
                      child: ServiceChip(
                        label: "Tires",
                        icon: Iconpath.wheelIcon,
                      ),
                    ),
                    Expanded(
                      child: ServiceChip(
                        label: "Electrical",
                        icon: Iconpath.electricIcon,
                      ),
                    ),
                    Expanded(
                      child: ServiceChip(
                        label: "Spares",
                        icon: Iconpath.spareIcon,
                        onTap: () {
                          Get.toNamed(Approute.getBrakePadsScreen());
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Rated Garages",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Approute.getGarageListPage());
                  },
                  child: const Text("View All"),
                ),
              ],
            ),
            Obx(() {
              if (controller.isLoadingGarages.value) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.garages.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      'No garages available',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: controller.garages
                    .map((garage) => GarageCard(garage: garage))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
