import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/auth/sign_in/controller/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController(), fenix: true);
    Get.lazyPut<ApiClient>(() => ApiClient(sharedPreferences: Get.find()), fenix: true);
  }
}
