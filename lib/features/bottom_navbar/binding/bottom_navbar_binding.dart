import 'package:get/get.dart';
import 'package:yousef1234321/features/bottom_navbar/controller/bottom_navbar_controller.dart';
import 'package:yousef1234321/features/home/home_page/controller/home_controller.dart';
import 'package:yousef1234321/features/home/home_page/service/home_service.dart';
import 'package:yousef1234321/features/service/service%20page/controller/service_controller.dart';
import 'package:yousef1234321/features/service/service%20page/service/service_page_service.dart';
import 'package:yousef1234321/features/spare_parts/controller/spare_parts_controller.dart';
import 'package:yousef1234321/features/spare_parts/service/spare_parts_service.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';
import 'package:yousef1234321/features/profile/profile_page/service/profile_service.dart';
import 'package:yousef1234321/features/chat/controller/chat_page_controller.dart';
import 'package:yousef1234321/features/chat/service/chat_page_service.dart';

class BottomNavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavbarController>(
      () => BottomNavbarController(),
      fenix: true,
    );

    // Inject Home dependencies
    Get.lazyPut<HomeService>(() => HomeService(Get.find()), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(Get.find()), fenix: true);
    Get.lazyPut<ServicePageService>(
      () => ServicePageService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ServiceController>(
      () => ServiceController(Get.find()),
      fenix: true,
    );

    // Inject Spare Parts dependencies
    Get.lazyPut<SparePartsService>(
      () => SparePartsService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<SparePartsController>(
      () => SparePartsController(Get.find()),
      fenix: true,
    );

    // Inject Profile dependencies
    Get.lazyPut<ProfileService>(() => ProfileService(Get.find()), fenix: true);
    Get.lazyPut<ProfileController>(
      () => ProfileController(Get.find()),
      fenix: true,
    );

    // Inject Chat dependencies
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
