import 'package:get/get.dart';

class LanguageController extends GetxController {
  // List of selectable languages
  final languages = ["English", "Hindi", "Arabic"];

  // Currently selected language
  var selectedLanguage = "English".obs;

  // Change selected language
  void changeLanguage(String lang) {
    selectedLanguage.value = lang;
  }
}
