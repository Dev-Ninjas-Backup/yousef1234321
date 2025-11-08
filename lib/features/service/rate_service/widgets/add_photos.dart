import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../controller/service_review_controller.dart';

class AddPhotos extends StatelessWidget {
  const AddPhotos({super.key, required this.controller});

  final ServiceReviewController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pickedImage = controller.image.value;

      return GestureDetector(
        onTap: () {
          controller.pickImage();
          debugPrint("=====================image picked");
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 0),
                blurRadius: 6,
                spreadRadius: 0,
                color: const Color(0xFF000000).withValues(alpha: .22),
              ),
            ],
          ),
          child: Center(
            child: pickedImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_sharp,
                        size: 24,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 6),
                      Text("Add Photo", style: getTextStyle(fontSize: 12)),
                    ],
                  )
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          pickedImage,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: controller.removeImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: .6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
