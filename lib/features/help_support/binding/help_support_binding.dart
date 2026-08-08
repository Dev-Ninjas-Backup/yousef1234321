import 'package:get/get.dart';
import 'package:yousef1234321/features/help_support/controller/help_support_controller.dart';
import 'package:yousef1234321/features/help_support/service/help_support_service.dart';

class HelpSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelpSupportService>(() => HelpSupportService(), fenix: true);
    Get.lazyPut<HelpSupportController>(
      () => HelpSupportController(Get.find()),
      fenix: true,
    );
  }
}
