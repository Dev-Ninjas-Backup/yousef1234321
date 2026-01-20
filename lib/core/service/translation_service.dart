// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:yousef1234321/secrets/api_keys.dart';

class TranslationService extends GetxService {
  final _cache = <String, String>{};

  Future<String> translate(String text, {String? targetLanguage}) async {
    var targetLang = targetLanguage ?? Get.locale?.languageCode ?? 'en';

    // Normalize language code (e.g. ar_SA -> ar, hi_IN -> hi)
    if (targetLang.contains('_')) {
      targetLang = targetLang.split('_')[0];
    }
    if (targetLang.contains('-')) {
      targetLang = targetLang.split('-')[0];
    }

    // Don't translate if the target language is English
    if (targetLang == 'en') {
      return text;
    }

    final cacheKey = '$text-$targetLang';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    // Premium Google Translate API Key
    const apiKey = googleTranslateApiKey;

    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$apiKey',
    );

    // print('TranslationService: Translating "$text" to "$targetLang"...');

    try {
      final response = await http.post(
        url,
        body: {'q': text, 'target': targetLang, 'format': 'text'},
      );

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        final translatedText =
            body['data']['translations'][0]['translatedText'];

        // Decode HTML entities that might be returned
        final decodedText = Bidi.stripHtmlIfNeeded(translatedText);

        _cache[cacheKey] = decodedText;
        return decodedText;
      } else {
        // Handle API error, maybe log it
        print(
          'TranslationService Error: ${response.statusCode} - ${response.body}',
        );
        return text; // Fallback to original text
      }
    } catch (e) {
      print('TranslationService Exception: $e');
      return text; // Fallback to original text
    }
  }
}
