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
        itemBuilder: (_, i) => Image.asset(all[i], height: 40,width: 40,),
        separatorBuilder: (_, __) => const SizedBox(width: 20),
      ),
    );
  }
}
