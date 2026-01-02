import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLang = _prefs.getString('language_name');

    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }

    // Note: We don't call Get.updateLocale here because onInit runs before GetMaterialApp is built.
    // The initial locale is handled in app.dart using the initialLocale getter below.
  }

  Locale? get initialLocale {
    final savedCode = _prefs.getString('language_code');
    final savedCountry = _prefs.getString('country_code');
    if (savedCode != null && savedCountry != null) {
      return Locale(savedCode, savedCountry);
    }
    return null;
  }

  void changeLanguage(String name, String code, String country) {
    selectedLanguage.value = name;
    _prefs.setString('language_name', name);
    _prefs.setString('language_code', code);
    _prefs.setString('country_code', country);
    Get.updateLocale(Locale(code, country));
  }
}
