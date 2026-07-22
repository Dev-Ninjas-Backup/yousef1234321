import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/controller/signup_otp_controller.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/service/signup_otp_service.dart';

class SignupOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<SignupOtpService>(
      () => SignupOtpService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<SignupOtpController>(
      () => SignupOtpController(Get.find()),
      fenix: true,
    );
  }
}
