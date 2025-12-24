import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/routes/app_route.dart';

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
    _checkAuthStatus();
  }

  /// Check if user is already logged in
  void _checkAuthStatus() {
    Future.delayed(const Duration(seconds: 3), () {
      if (ApiClient.to.isLoggedIn) {
        print(
          "User is logged in, token: ${ApiClient.to.token}",
        );
        // User is logged in, navigate to home
        Get.offAllNamed(Approute.bottomNavBarScreen);
      } else {
        print("User is not logged in");
        // User is not logged in, show onboarding
        Get.offAllNamed('/onboardingScreen');
      }
    });
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
