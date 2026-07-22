import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';
import 'package:yousef1234321/features/profile/profile_page/service/profile_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileService>(() => ProfileService(Get.find()), fenix: true);
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find()),
      fenix: true,
    );
  }
}
