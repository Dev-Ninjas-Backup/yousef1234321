import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/profile/edit_profile/controller/edit_profile_controller.dart';

class BuildPhoneField extends StatelessWidget {
  const BuildPhoneField({super.key, required this.controller});

  final EditProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "mobile_number".tr,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: "mobile_number".tr,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
