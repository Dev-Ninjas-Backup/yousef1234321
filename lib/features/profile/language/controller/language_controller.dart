import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/language/service/language_service.dart';

class LanguageController extends GetxController {
  final LanguageService _languageService;

  LanguageController(this._languageService);
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    final savedLang = _languageService.getSavedLanguageName();

    if (savedLang != null) {
      selectedLanguage.value = savedLang;
    }

    // Note: We don't call Get.updateLocale here because onInit runs before GetMaterialApp is built.
    // The initial locale is handled in app.dart using the initialLocale getter below.
  }

  Locale? get initialLocale {
    final savedCode = _languageService.getSavedLanguageCode();
    final savedCountry = _languageService.getSavedCountryCode();
    if (savedCode != null && savedCountry != null) {
      return Locale(savedCode, savedCountry);
    }
    return const Locale('en', 'US');
  }

  void changeLanguage(String name, String code, String country) {
    selectedLanguage.value = name;
    _languageService.saveLanguage(name, code, country);
    Get.updateLocale(Locale(code, country));
  }
}
