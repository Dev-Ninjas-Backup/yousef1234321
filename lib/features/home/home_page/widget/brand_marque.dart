import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';

class BrandMarqueeView extends StatelessWidget {
  BrandMarqueeView({super.key});

  final controller = Get.put(HomeController());

  final brands = [
    Imagepath.slide1,
    Imagepath.slide2,
    Imagepath.slide3,
    Imagepath.slide4,
    Imagepath.slide5,
    Imagepath.slide6,
    Imagepath.slide7,
    Imagepath.slide8,
    Imagepath.slide9,
    Imagepath.slide10,
    Imagepath.slide11,
    Imagepath.slide12,
    Imagepath.slide13,
    Imagepath.slide14,
    Imagepath.slide15,
    Imagepath.slide16,
    Imagepath.slide17,
    Imagepath.slide18,
    Imagepath.slide19,
    Imagepath.slide20,
    Imagepath.slide21,
    Imagepath.slide22,
    Imagepath.slide23,
    Imagepath.slide24,
    Imagepath.slide26,
    Imagepath.slide27,
    Imagepath.slide28,
    Imagepath.slide29,
    Imagepath.slide30,
    Imagepath.slide31,
    Imagepath.slide32,
    Imagepath.slide33,
    Imagepath.slide34,
    Imagepath.slide35,
    Imagepath.slide36,
    Imagepath.slide37,
    Imagepath.slide38,
    Imagepath.slide40,
    Imagepath.slide41,
    Imagepath.slide42,
    Imagepath.slide43,
    Imagepath.slide44,
    Imagepath.slide45,
    Imagepath.slide46,
    Imagepath.slide47,
    Imagepath.slide48,
    Imagepath.slide49,
    Imagepath.slide50,
    Imagepath.slide51,
    Imagepath.slide52,
    Imagepath.slide54,
    Imagepath.slide55,
  ];

  @override
  Widget build(BuildContext context) {
    final all = [...brands, ...brands]; // for continuous loop

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      height: 50,
      child: ListView.separated(
        controller: controller.scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: all.length,
        itemBuilder: (_, i) => Image.asset(all[i], height: 40, width: 40),
        separatorBuilder: (_, __) => const SizedBox(width: 20),
      ),
    );
  }
}
