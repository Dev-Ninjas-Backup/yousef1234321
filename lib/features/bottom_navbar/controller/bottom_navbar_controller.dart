import 'package:get/get.dart';
import '../../service/service page/controller/service_controller.dart';

class BottomNavbarController extends GetxController {
  var currentIndex = 2.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
    if (index == 0) {
      if (Get.isRegistered<ServiceController>()) {
        final serviceController = Get.find<ServiceController>();
        serviceController.radiusController.clear();
        serviceController.resetToApprovedGarages();
      }
    }
  }
}
