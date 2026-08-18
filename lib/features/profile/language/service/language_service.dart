import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  final SharedPreferences _prefs;

  LanguageService(this._prefs);

  String? getSavedLanguageName() => _prefs.getString('language_name');

  String? getSavedLanguageCode() => _prefs.getString('language_code');

  String? getSavedCountryCode() => _prefs.getString('country_code');

  Future<void> saveLanguage(String name, String code, String country) async {
    await _prefs.setString('language_name', name);
    await _prefs.setString('language_code', code);
    await _prefs.setString('country_code', country);
  }
}
