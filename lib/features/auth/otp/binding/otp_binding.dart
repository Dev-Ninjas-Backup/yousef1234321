import 'package:get/get.dart';
import 'package:yousef1234321/features/auth/otp/controller/otp_controller.dart';
import 'package:yousef1234321/features/auth/otp/service/otp_service.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<OtpService>(() => OtpService(Get.find()), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(Get.find()), fenix: true);
  }
}
