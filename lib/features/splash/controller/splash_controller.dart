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
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      currentImageIndex.value = (currentImageIndex.value + 1) % images.length;
      return true;
    });
  }
}
