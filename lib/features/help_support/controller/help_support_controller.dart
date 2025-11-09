import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportController extends GetxController {
  Future<void> contactSupport() async {
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/8801700000000",
    ); // replace with your number
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not open WhatsApp.");
    }
  }

  Future<void> emailSupport() async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: 'support@yourapp.com',
      query: 'subject=Support Request&body=Hi, I need help with...',
    );

    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      Get.snackbar("Error", "Could not open email app.");
    }
  }
}
