import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/rate_service/controller/service_review_controller.dart';
import 'package:yousef1234321/features/service/rate_service/service/service_review_service.dart';

class ServiceReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceReviewService>(
      () => ServiceReviewService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceReviewController>(
      () => ServiceReviewController(Get.find()),
      fenix: true,
    );
  }
}
