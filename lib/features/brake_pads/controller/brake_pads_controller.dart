import 'package:get/get.dart';

class BrakePadsController extends GetxController {
  var selectedImageIndex = 0.obs;

  final List<String> images = [
    'assets/images/spare_parts5.png',
    'assets/images/spare_parts1.png',
    'assets/images/spare_parts2.png',
    'assets/images/spare_parts3.png',
  ];

  void changeImage(int index) {
    selectedImageIndex.value = index;
  }
}
