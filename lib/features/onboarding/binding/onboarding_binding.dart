import 'package:get/get.dart';
import 'package:yousef1234321/features/onboarding/controller/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
      fenix: true,
    );
  }
}
