import 'package:url_launcher/url_launcher.dart';

class HelpSupportService {
  Future<bool> launchWhatsApp(String number) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(whatsappUrl)) {
      return await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  Future<bool> launchEmail(String email, String subject, String body) async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=$subject&body=$body',
    );
    if (await canLaunchUrl(emailUrl)) {
      return await launchUrl(emailUrl);
    }
    return false;
  }
}
