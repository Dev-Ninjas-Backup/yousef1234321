import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_up/controller/sign_up_controller.dart';
import 'package:yousef1234321/features/auth/sign_up/service/sign_up_service.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<SignUpService>(() => SignUpService(Get.find()), fenix: true);
    Get.put<SignUpController>(SignUpController(Get.find()));
  }
}
