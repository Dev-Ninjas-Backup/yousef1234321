import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:yousef1234321/features/auth/sign_in/service/sign_in_service.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(
      () => ApiClient(sharedPreferences: Get.find()),
      fenix: true,
    );
    Get.lazyPut<SignInService>(() => SignInService(Get.find()), fenix: true);
    Get.lazyPut<SignInController>(
      () => SignInController(Get.find()),
      fenix: true,
    );
  }
}
