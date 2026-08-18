import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/edit_profile/controller/edit_profile_controller.dart';
import 'package:yousef1234321/features/profile/edit_profile/service/edit_profile_service.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileService>(
      () => EditProfileService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(Get.find()),
      fenix: true,
    );
  }
}
