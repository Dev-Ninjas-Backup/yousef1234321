import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/service%20page/controller/service_controller.dart';
import 'package:yousef1234321/features/service/service%20page/service/service_page_service.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServicePageService>(
      () => ServicePageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(Get.find()),
      fenix: true,
    );
  }
}
