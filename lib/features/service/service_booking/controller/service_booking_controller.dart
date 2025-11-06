import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';

class ServiceBookingController extends GetxController {
  var images = [
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
  ].obs;

  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
