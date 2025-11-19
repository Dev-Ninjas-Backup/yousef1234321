import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/language_controller.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Language")),
      body: ListView.builder(
        itemCount: controller.languages.length,
        itemBuilder: (context, index) {
          final lang = controller.languages[index];
          return Obx(() {
            final isSelected = controller.selectedLanguage.value == lang;
            return ListTile(
              title: Text(lang),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onTap: () {
                controller.changeLanguage(lang);
              },
            );
          });
        },
      ),
    );
  }
}
