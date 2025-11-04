import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;

  var currentImageIndex = 0.obs;
  final List<String> images = [Imagepath.find, Imagepath.fix, Imagepath.drive];

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    super.onInit();

    _startImageRotation();
  }

  void _startImageRotation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 2));
      currentImageIndex.value = (currentImageIndex.value + 1) % images.length;
      return true;
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
// late AnimationController animationController;

// @override
// void onInit() {
//   animationController = AnimationController(
//     vsync: this,
//     duration: const Duration(seconds: 5),
//   )..repeat();

//   super.onInit();
// }

// @override
// void onClose() {
//   animationController.dispose();
//   super.onClose();
// }
