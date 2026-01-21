import 'package:get/get.dart';
import 'package:yousef1234321/core/service/translation_service.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(TranslationService());
    // Get.lazyPut<HomeController>(() => HomeController());
  }
}
