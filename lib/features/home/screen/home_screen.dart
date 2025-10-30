import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/home/controller/home_controller.dart';
import 'package:yousef1234321/features/home/widget/garage_card.dart';
import 'package:yousef1234321/features/home/widget/search_section.dart';
import 'package:yousef1234321/features/home/widget/service_chip.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.directions_car, color: Colors.blue),
            SizedBox(width: 8),
            Text("SayaraHub", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.1),
            child: Icon(Icons.notifications_none),
          ),
          SizedBox(width: 12),
          CircleAvatar(
            backgroundImage: NetworkImage(
              "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?cs=srgb&dl=pexels-italo-melo-881954-2379004.jpg&fm=jpg",
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    ServiceChip(label: "AC Repair", icon: Icons.ac_unit),
                    ServiceChip(label: "Battery", icon: Icons.battery_full),
                    ServiceChip(label: "Engine", icon: Icons.build),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  spacing: 10,
                  children: [
                    ServiceChip(label: "Tires", icon: Icons.tire_repair),
                    ServiceChip(label: "Electrical", icon: Icons.flash_on),
                    ServiceChip(label: "Spares", icon: Icons.settings),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Rated Garages",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(onPressed: () {}, child: const Text("View All")),
              ],
            ),
            Obx(
              () => Column(
                children: controller.garages
                    .map((garage) => GarageCard(garage: garage))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
