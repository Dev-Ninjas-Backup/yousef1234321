import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/features/home/home_page/screen/home_screen.dart';
import 'package:yousef1234321/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:yousef1234321/features/spare_parts/screen/spare_parts_screen.dart';
import 'package:yousef1234321/features/support/screen/support_page.dart';
import '../../profile/profile_page/scrreen/profile_page.dart';
import '../../service/service page/screen/find_service.dart';

class BottomNavbarScreen extends StatelessWidget {
  BottomNavbarScreen({super.key});

  final BottomNavbarController controller = Get.put(BottomNavbarController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      FindService(),
      SparePartsScreen(),
      HomeScreen(),
      ChatPage(),
      ProfilePage(),
    ];

    final List<String> icons = [
      Iconpath.bottom1,
      Iconpath.bottom2,
      Iconpath.homeIcon,
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
        backgroundColor: Colors.white,
        body: pages[controller.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(430, 65),
              topRight: Radius.elliptical(430, 65),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                //color: Colors.red,
                color: Color(0xFFAFB8C6).withValues(alpha: .18),
                spreadRadius: 0,
                blurRadius: 16,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.only(bottom: 40, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(icons.length, (index) {
              bool isSelected = controller.currentIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeIndex(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset(
                    //   icons[index],

                    //   height: index == 2 ? 50 : 25,
                    //   width: index == 2 ? 50 : 25,

                    //   // width: 28,
                    //   // height: 28,
                    //   color: index == 2
                    //       ? null
                    //       : (isSelected ? Colors.blue : Colors.grey),
                    // ),
                    SizedBox(
                      height: index == 2 ? 50 : 25,
                      width: index == 2 ? 50 : 25,
                      child: Image.asset(
                        icons[index],
                        fit: BoxFit
                            .contain, // ensures the image scales to the size
                        color: index == 2
                            ? null
                            : (isSelected ? Colors.blue : Colors.grey),
                      ),
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
