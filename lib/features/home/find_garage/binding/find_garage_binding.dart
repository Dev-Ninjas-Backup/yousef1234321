import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/home/find_garage/controller/find_garage_controller.dart';
import 'package:yousef1234321/features/home/find_garage/service/find_garage_service.dart';

class FindGarageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<FindGarageService>(
      () => FindGarageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<FindGarageController>(
      () => FindGarageController(Get.find()),
      fenix: true,
    );
  }
}
