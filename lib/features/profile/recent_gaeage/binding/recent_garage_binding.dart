import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/recent_gaeage/controller/recent_garage_controller.dart';
import 'package:yousef1234321/features/profile/recent_gaeage/service/recent_garage_service.dart';

class RecentGarageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentGarageService>(() => RecentGarageService(), fenix: true);
    Get.lazyPut<RecentGarageController>(
      () => RecentGarageController(Get.find()),
      fenix: true,
    );
  }
}
