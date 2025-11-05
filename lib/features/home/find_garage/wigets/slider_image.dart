import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/style/global_text_style.dart';
import '../controller/find_charger_controller.dart' show FindChargerController;

class SliderImge extends StatelessWidget {
  const SliderImge({super.key, required this.controller});

  final FindChargerController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.images.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Obx(() {
            double scale = (controller.currentPage.value - index).abs();
            double size = 1 - (scale * 0.3);
            if (size < 0.7) size = 0.7;

            return AnimatedScale(
              scale: size,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(controller.images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    right: 15,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              "xyz, Abu Dhabi",
                              style: getTextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
