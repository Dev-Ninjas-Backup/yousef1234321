import 'package:get/get.dart';
import 'package:yousef1234321/features/brake_pads/controller/brake_pads_controller.dart';
import 'package:yousef1234321/features/brake_pads/service/brake_pads_service.dart';

class BrakePadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrakePadsService>(
      () => BrakePadsService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<BrakePadsController>(
      () => BrakePadsController(Get.find()),
      fenix: true,
    );
  }
}
