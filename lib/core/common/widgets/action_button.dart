  import 'package:flutter/material.dart';

import '../style/global_text_style.dart';

Widget actionButton(
    String text, {
    Color? color,
    Color? borderColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color ?? Colors.transparent,
          border: Border.all(color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: getTextStyle(
            fontSize: 10,
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

