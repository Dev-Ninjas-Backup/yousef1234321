import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/home/screen/home_screen.dart';
import 'package:yousef1234321/features/bottom_navbar/controller/bottom_navbar_controller.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
      HomeScreen(),
    ];

    final List<String> icons = [
      Iconpath.bottom1,
      Iconpath.bottom2,
      "assets/icons/bottom_3.png",
      Iconpath.bottom4,
      Iconpath.bottom5,
    ];

    final List<String> labels = [
      "Service",
      "Spare Parts",
      "Home",
      "Support",
      "Profile",
    ];

    return Obx(
      () => Scaffold(
        backgroundColor: Colors.grey[100],
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.only(bottom: 20, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (index) {
              bool isSelected = controller.currentIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeIndex(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      icons[index],

                      width: 28,
                      height: 28,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
