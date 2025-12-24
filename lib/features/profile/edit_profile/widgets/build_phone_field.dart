import 'package:country_code_picker/country_code_picker.dart';
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
          const Text(
            "Mobile Number",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CountryCodePicker(
                    onChanged: (country) {
                      controller.countryCode.value = country.dialCode ?? "+880";
                    },
                    // Use controller value so picker reflects API/previous selection
                    initialSelection: controller.countryCode.value,
                    favorite: [controller.countryCode.value, 'BD'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    showFlag: true,
                    padding: EdgeInsets.zero,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: "Mobile Number",
                    hintStyle: const TextStyle(color: Colors.grey),
                    // suffixIcon: const Icon(
                    //   Icons.check_circle,
                    //   color: Colors.blue,
                    // ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
