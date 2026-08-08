import 'package:get/get.dart';
import 'package:yousef1234321/features/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
  }
}
