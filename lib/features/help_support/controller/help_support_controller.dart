import 'package:get/get.dart';
import 'package:yousef1234321/features/help_support/service/help_support_service.dart';

class HelpSupportController extends GetxController {
  final HelpSupportService _helpSupportService;

  HelpSupportController(this._helpSupportService);

  Future<void> contactSupport() async {
    final success = await _helpSupportService.launchWhatsApp("8801700000000");
    if (!success) {
      Get.snackbar("Error", "Could not open WhatsApp.");
    }
  }

  Future<void> emailSupport() async {
    final success = await _helpSupportService.launchEmail(
      'support@yourapp.com',
      'Support Request',
      'Hi, I need help with...',
    );
    if (!success) {
      Get.snackbar("Error", "Could not open email app.");
    }
  }
}
