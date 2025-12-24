import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/contact_us/controller/contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContactUsController());
    InputDecoration fieldDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 0.7),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey, width: 0.7),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(title: "Contact Us"),
            const SizedBox(height: 35),

            const Text(
              "Need Help? We’re Here for You",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              "If you have any questions, feedback, or issues, just fill out the form below. Our team will get back to you as soon as possible.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 28),
            Image.asset(
              "assets/images/contact_us.png",
              height: 180,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            // TextFields
            Obx(
              () => TextField(
                controller: controller.nameController,
                decoration: fieldDecoration("Your name"),
                enabled: !controller.isLoadingProfile.value,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => TextField(
                controller: controller.emailController,
                decoration: fieldDecoration("Your email address"),
                enabled: !controller.isLoadingProfile.value,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller.messageController,
              maxLines: 4,
              decoration: fieldDecoration("Write message..."),
            ),

            const SizedBox(height: 24),

            // Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSending.value
                      ? null
                      : () {
                          controller.sendMessage();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isSending.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Send Message",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
