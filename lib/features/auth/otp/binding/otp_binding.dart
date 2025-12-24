import 'package:get/get.dart';
import 'package:yousef1234321/features/auth/otp/controller/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
