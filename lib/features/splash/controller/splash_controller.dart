import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';

class SplashController extends GetxController {
  var currentImageIndex = 0.obs;
  final List<String> images = [
    Iconpath.smart,
    Iconpath.service,
    Iconpath.secure,
  ];

  @override
  void onInit() {
    super.onInit();
    _startImageRotation();
  }

  void _startImageRotation() {
    Future.delayed(Duration(seconds: 1), () {
      if (currentImageIndex.value < images.length - 1) {
        currentImageIndex.value++;
      } else {
        currentImageIndex.value = 0;
      }
      _startImageRotation();
    });
  }
}
