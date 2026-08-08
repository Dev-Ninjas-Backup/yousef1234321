import 'package:get/get.dart';
import 'package:yousef1234321/features/chat/controller/chat_page_controller.dart';
import 'package:yousef1234321/features/chat/service/chat_page_service.dart';

class ChatPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatPageService>(
      () => ChatPageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ChatPageController>(
      () => ChatPageController(Get.find()),
      fenix: true,
    );
  }
}
