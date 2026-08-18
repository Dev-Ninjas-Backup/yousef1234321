import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/language/controller/language_controller.dart';
import 'package:yousef1234321/features/profile/language/service/language_service.dart';

class LanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageService>(
      () => LanguageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<LanguageController>(
      () => LanguageController(Get.find()),
      fenix: true,
    );
  }
}
