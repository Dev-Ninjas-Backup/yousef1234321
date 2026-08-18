import 'package:get/get.dart';
import 'package:yousef1234321/features/contact_us/controller/contact_us_controller.dart';
import 'package:yousef1234321/features/contact_us/service/contact_us_service.dart';

class ContactUsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactUsService>(
      () => ContactUsService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ContactUsController>(
      () => ContactUsController(Get.find()),
      fenix: true,
    );
  }
}
