import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/forget_password/controller/forget_password_controller.dart';
import 'package:yousef1234321/features/auth/forget_password/service/forget_password_service.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<ForgetPasswordService>(
      () => ForgetPasswordService(Get.find()),
      fenix: true,
    );
    Get.put<ForgetPasswordController>(ForgetPasswordController(Get.find()));
  }
}
