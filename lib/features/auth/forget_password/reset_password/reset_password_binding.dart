import 'package:get/get.dart';
import 'package:yousef1234321/features/auth/forget_password/reset_password/reset_password_controller.dart';
import 'package:yousef1234321/features/auth/forget_password/service/forget_password_service.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgetPasswordService>(
      () => ForgetPasswordService(Get.find()),
      fenix: true,
    );
    Get.put<ResetPasswordController>(ResetPasswordController(Get.find()));
  }
}
