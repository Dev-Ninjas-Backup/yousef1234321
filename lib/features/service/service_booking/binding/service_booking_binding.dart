import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/service_booking/controller/service_booking_controller.dart';
import 'package:yousef1234321/features/service/service_booking/service/service_booking_service.dart';

class ServiceBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceBookingService>(
      () => ServiceBookingService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceBookingController>(
      () => ServiceBookingController(Get.find()),
      fenix: true,
    );
  }
}
