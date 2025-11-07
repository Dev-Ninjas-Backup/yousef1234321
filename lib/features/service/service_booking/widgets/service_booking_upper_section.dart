import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/constants/iconpath.dart';
import '../controller/service_booking_controller.dart';
class ServiceBookingUpperSection extends StatelessWidget {
  const ServiceBookingUpperSection({super.key, required this.controller});
  final ServiceBookingController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //  Large Top Image — scrollable
        Stack(
          children: [
            Obx(
              () => SizedBox(
                height: 263,
                width: double.infinity,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentIndex.value = index;
                  },
                  itemCount: controller.images.length,
                  itemBuilder: (context, index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        controller.images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 40,
              child: GestureDetector(
              onTap: () {
                Get.back();
              }
              ,
              child: Image.asset(Iconpath.arrowback, height: 44, width: 44)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Thumbnails Row
        Obx(() {
          int maxVisible = 4;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                controller.images.length > maxVisible
                    ? maxVisible
                    : controller.images.length,
                (index) {
                  bool isSelected = controller.currentIndex.value == index;
                  return GestureDetector(
                    onTap: () {
                      controller.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            controller.images[index],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (controller.images.length > maxVisible)
                Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: Offset(0, 1),
                        color: Color(0xFF000000).withValues(alpha: 0.05),
                      ),
                    ],
                  ),

                  child: Text(
                    '+${controller.images.length - maxVisible}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}
