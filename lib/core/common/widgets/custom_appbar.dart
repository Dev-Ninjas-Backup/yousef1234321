import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

import '../constants/iconpath.dart';
import '../style/global_text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showBackButton)
          GestureDetector(
            onTap:
                onBackPressed ??
                () {
                  Get.back();
                },
            child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
          )
        else
          const SizedBox(width: 44),
        TranslatedText(
          text: title,
          style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 44),
      ],
    );
  }
}
