import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/location/controller/location_page_controller.dart';
import 'package:yousef1234321/features/profile/location/service/location_page_service.dart';

class LocationPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationPageService>(
      () => LocationPageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<LocationPageController>(
      () => LocationPageController(Get.find()),
      fenix: true,
    );
  }
}
