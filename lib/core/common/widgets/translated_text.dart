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

    return FutureBuilder<String>(
      future: translationService.translate(text),
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
