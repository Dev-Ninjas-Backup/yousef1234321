import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/my_listing/conrtoller/listing_controller.dart';
import 'package:yousef1234321/features/profile/my_listing/service/my_listing_service.dart';

class MyListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyListingService>(
      () => MyListingService(Get.find()),
      fenix: true,
    );
    Get.lazyPut<ListingController>(
      () => ListingController(Get.find()),
      fenix: true,
    );
  }
}
