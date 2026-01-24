import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

class ServiceChip extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback? onTap;

  const ServiceChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(icon, height: 32, width: 32, fit: BoxFit.contain),
            const SizedBox(width: 6),
            Expanded(
              child: TranslatedText(
                text: label,
                maxLines: 2,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
