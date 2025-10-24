import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  void nextPage() {
    if (currentIndex.value < 3) {
      currentIndex.value++;
    } else {
      Get.offAllNamed('/signInScreen');
    }
  }
}
