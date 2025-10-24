import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';

class SocialButton extends StatelessWidget {
  final String imagePath;
  final String text;
  final VoidCallback? onTap;

  const SocialButton({
    Key? key,
    required this.imagePath,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.splashButtonColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 24, width: 24),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
