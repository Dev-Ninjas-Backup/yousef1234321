import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/service/translation_service.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign? textAlign;

  const TranslatedText({
    super.key,
    required this.text,
    this.style,
    this.overflow,
    this.maxLines,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    // If the text is empty, just return an empty container to avoid API calls.
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    final TranslationService translationService = Get.find();

    // Check if 'text' is a key in the English dictionary.
    // If it is, use the English value as the source for translation.
    // This allows us to pass keys (e.g. 'hello') and translate the actual word ('Hello').
    String sourceText = text;
    final englishMap = Get.translations['en_US'];
    final bool isKey = englishMap != null && englishMap.containsKey(text);

    if (isKey) {
      sourceText = englishMap[text]!;

      // Optimization: Check if we have a static translation available locally to avoid API calls.

      // 1. If current language is English, use the English value directly.
      if (Get.locale?.languageCode == 'en') {
        return Text(
          sourceText,
          style: style,
          overflow: overflow,
          maxLines: maxLines,
          textAlign: textAlign,
        );
      }

      // 2. If not English, check if GetX has a translation that is different from the English fallback.
      // text.tr will return the translated value if found, or the fallback (English value) if not.
      if (text.tr != sourceText) {
        return Text(
          text.tr,
          style: style,
          overflow: overflow,
          maxLines: maxLines,
          textAlign: textAlign,
        );
      }
    }

    return FutureBuilder<String>(
      future: translationService.translate(sourceText),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('...', style: style);
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print("Error translating '$text': ${snapshot.error}");
            // Show an error indicator in the UI in debug mode
            return Text(
              '$text [E]',
              style: style,
              overflow: overflow,
              maxLines: maxLines,
              textAlign: textAlign,
            );
          }
          // Fallback to original text in release
          return Text(
            text,
            style: style,
            overflow: overflow,
            maxLines: maxLines,
            textAlign: textAlign,
          );
        }

        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: style,
            overflow: overflow,
            maxLines: maxLines,
            textAlign: textAlign,
          );
        }

        // Default fallback
        return Text(
          text,
          style: style,
          overflow: overflow,
          maxLines: maxLines,
          textAlign: textAlign,
        );
      },
    );
  }
}
