import 'package:get/get.dart';
import 'package:yousef1234321/features/payment/controller/payment_controller.dart';
import 'package:yousef1234321/features/payment/service/payment_service.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentService>(() => PaymentService(), fenix: true);
    Get.lazyPut<PaymentController>(
      () => PaymentController(Get.find()),
      fenix: true,
    );
  }
}
