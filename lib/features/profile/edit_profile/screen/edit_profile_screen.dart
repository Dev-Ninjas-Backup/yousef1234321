import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/edit_profile/controller/edit_profile_controller.dart';
import 'package:yousef1234321/features/profile/edit_profile/widgets/build_field.dart';
import 'package:yousef1234321/features/profile/edit_profile/widgets/build_phone_field.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(title: "edit_profile"),
            SizedBox(height: 24),

            // Profile Avatar
            Center(
              child: Stack(
                children: [
                  Obx(
                    () => CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.selectedImage.value != null
                          ? FileImage(controller.selectedImage.value!)
                          : (controller.profilePhotoUrl.value != null
                                ? NetworkImage(
                                    controller.profilePhotoUrl.value!,
                                  )
                                : null),
                      // If there's no background image, show a person icon
                      child:
                          controller.selectedImage.value == null &&
                              controller.profilePhotoUrl.value == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Name
            Obx(
              () => Text(
                controller.fullName.value.isNotEmpty
                    ? controller.fullName.value
                    : '${controller.firstNameController.text} ${controller.lastNameController.text}'
                          .trim(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Obx(
              () => Text(
                controller.email.value.isNotEmpty
                    ? controller.email.value
                    : 'No email',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 35),

            BuildField(
              label: "first_name".tr,
              controller: controller.firstNameController,
            ),
            BuildField(
              label: "last_name".tr,
              controller: controller.lastNameController,
            ),
            BuildField(
              label: "address".tr,
              controller: controller.addressController,
            ),
            BuildField(label: "city".tr, controller: controller.cityController),
            BuildPhoneField(controller: controller),
            BuildField(
              label: "emirate".tr,
              controller: controller.emirateController,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: 215,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "save_changes".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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
