import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/home/garage_list/controller/garage_list_controller.dart';
import 'package:yousef1234321/features/home/garage_list/service/garage_list_service.dart';

class GarageListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<GarageListService>(
      () => GarageListService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<GarageListController>(
      () => GarageListController(Get.find()),
      fenix: true,
    );
  }
}
