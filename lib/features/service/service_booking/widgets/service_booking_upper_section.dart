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
                    final imageUrl = controller.images[index];
                    final isNetworkImage =
                        imageUrl.startsWith('http://') ||
                        imageUrl.startsWith('https://');

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: isNetworkImage
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.garage,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.asset(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(
                                      Icons.garage,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
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
                },
                child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
              ),
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
                          child: Builder(
                            builder: (context) {
                              final imageUrl = controller.images[index];
                              final isNetworkImage =
                                  imageUrl.startsWith('http://') ||
                                  imageUrl.startsWith('https://');

                              return isNetworkImage
                                  ? Image.network(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.garage,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    )
                                  : Image.asset(
                                      imageUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey.shade300,
                                              child: const Icon(
                                                Icons.garage,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    );
                            },
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
