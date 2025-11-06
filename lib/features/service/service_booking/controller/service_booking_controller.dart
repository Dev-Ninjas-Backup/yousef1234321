import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
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

  var services = [
    {"title": "AC Service", "icon": Iconpath.acIcon},
    {"title": "Battery Replacement", "icon": Iconpath.batterryIcon},
    {"title": "Tires", "icon": Iconpath.tire},
    {"title": "Engine Diagnostics", "icon": Iconpath.engineIcon},
    {"title": "Electrical", "icon": Iconpath.electricIcon},
    {"title": "Spares", "icon": Iconpath.spareIcon},
  ].obs;
    var isOpen = true.obs;

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
