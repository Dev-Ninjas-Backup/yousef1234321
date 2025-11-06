import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_controller.dart';

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({super.key, required this.controller});

  final ServiceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withValues(alpha: .05),
            offset: Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: "Enter your location",
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryColor,
                ),

                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Color.fromARGB(239, 110, 108, 108),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 14),

          Obx(() {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                dropdownColor: AppColors.splashButtonColor.withValues(
                  alpha: .75,
                ),
                borderRadius: BorderRadius.circular(8),
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 14,
                  color: Colors.white,
                ),
                underline: SizedBox.shrink(),
                padding: EdgeInsets.zero,
                hint: Text(
                  "Find by garages",
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                value: controller.selectedOption.value == ''
                    ? null
                    : controller.selectedOption.value,
                items: controller.options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    controller.changeOption(newValue);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
