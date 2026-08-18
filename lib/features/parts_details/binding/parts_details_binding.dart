import 'package:get/get.dart';
import 'package:yousef1234321/features/parts_details/controller/parts_details_controller.dart';
import 'package:yousef1234321/features/parts_details/service/parts_details_service.dart';

class PartsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartsDetailsService>(
      () => PartsDetailsService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<PartsDetailsController>(
      () => PartsDetailsController(Get.find()),
      fenix: true,
    );
  }
}
