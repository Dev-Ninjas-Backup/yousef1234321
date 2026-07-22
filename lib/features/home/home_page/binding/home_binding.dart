import 'package:get/get.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/service/home_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeService>(() => HomeService(Get.find()), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(Get.find()), fenix: true);
  }
}
