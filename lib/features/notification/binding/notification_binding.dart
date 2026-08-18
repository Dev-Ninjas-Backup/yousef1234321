import 'package:get/get.dart';
import 'package:yousef1234321/features/notification/controller/notification_controller.dart';
import 'package:yousef1234321/features/notification/service/notification_rest_service.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationServiceRest>(
      () => NotificationServiceRest(Get.find()),
      fenix: true,
    );
    Get.lazyPut<NotificationController>(
      () => NotificationController(Get.find()),
      fenix: true,
    );
  }
}
