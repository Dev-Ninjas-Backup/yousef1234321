import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import '../controller/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController controller = Get.put(LanguageController());

  final List<Map<String, String>> languages = [
    {'name': 'English', 'nativeName': 'English', 'code': 'en', 'country': 'US'},
    {'name': 'Hindi', 'nativeName': 'हिन्दी', 'code': 'hi', 'country': 'IN'},
    {'name': 'Arabic', 'nativeName': 'العربية', 'code': 'ar', 'country': 'SA'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomAppBar(title: 'select_language'.tr),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedLanguage.value == lang['name'];
                    return GestureDetector(
                      onTap: () {
                        controller.changeLanguage(
                          lang['name']!,
                          lang['code']!,
                          lang['country']!,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade200,
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lang['nativeName']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.black87,
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Colors.blue)
                            else
                              const Icon(
                                Icons.circle_outlined,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
