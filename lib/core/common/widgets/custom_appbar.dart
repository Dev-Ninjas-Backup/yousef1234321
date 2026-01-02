import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/iconpath.dart';
import '../style/global_text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
        ),
        Text(
          title.tr,
          style: getTextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 44),
      ],
    );
  }
}
