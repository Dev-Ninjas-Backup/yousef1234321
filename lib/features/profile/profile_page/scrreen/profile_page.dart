import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';

import '../widgets/delete_dialog.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());
  ProfilePage({super.key});

  Widget buildProfileImage() {
    // Display API profile photo or default avatar
    if (controller.profilePhoto.value != null &&
        controller.profilePhoto.value!.isNotEmpty) {
      // Show the default avatar until the network image has at least one frame.
      // This avoids showing a spinner first — the avatar is displayed until
      // the image data is available, then the image fades in.
      return Image.network(
        controller.profilePhoto.value!,
        height: 96.r,
        width: 96.r,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultAvatar();
        },
        // frameBuilder lets us control what is shown while the image loads.
        frameBuilder:
            (
              BuildContext context,
              Widget child,
              int? frame,
              bool wasSynchronouslyLoaded,
            ) {
              if (wasSynchronouslyLoaded) {
                return child; // already available
              }

              if (frame == null) {
                // Image is still loading — show default avatar (no spinner)
                return _buildDefaultAvatar();
              }

              // Image has loaded (at least one frame) — fade it in for a smooth effect
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: child,
              );
            },
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      height: 96.r,
      width: 96.r,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: 48.sp, color: AppColors.primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () => controller.fetchProfile(),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 52.h),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(title: "profile".tr),
                SizedBox(height: 30.h),
                Center(
                  child: Obx(
                    () => controller.isLoadingProfile.value
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              Obx(
                                () => ClipRRect(
                                  borderRadius: BorderRadius.circular(100.r),
                                  child: buildProfileImage(),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Obx(
                                () => Text(
                                  controller.fullName.value.isEmpty
                                      ? "user".tr
                                      : controller.fullName.value,
                                  style: getTextStyle(
                                    fontSize: 24.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Obx(
                                () => controller.email.value.isEmpty
                                    ? TranslatedText(
                                        text: "default_email",
                                        style: getTextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      )
                                    : Text(
                                        controller.email.value,
                                        style: getTextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 25.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFBDC6D3).withValues(alpha: .12),
                        blurRadius: 16.r,
                        spreadRadius: 0,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.profileItem.length,
                    itemBuilder: (_, index) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    controller.profileItem[index].icon,
                                    size: 24.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  TranslatedText(
                                    text: controller.profileItem[index].title,
                                    style: getTextStyle(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.profileItem[index].ontap?.call();
                                  controller.selectedIndex.value =
                                      index; // Update selected index
                                },
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 24.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Divider(thickness: .8.h),
                          SizedBox(height: 4.h),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 30.h),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.logout();
                        },
                        child: Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (controller.isLoggingOut.value)
                                  SizedBox(
                                    width: 16.w,
                                    height: 16.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.w,
                                    ),
                                  )
                                else
                                  Row(
                                    children: [
                                      TranslatedText(
                                        text: "logout",
                                        textAlign: TextAlign.center,
                                        style: getTextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(
                                        Icons.logout_sharp,
                                        size: 24.sp,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showDeletelDialog();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                            // color:Colors.amber,
                            border: Border.all(color: Colors.red, width: 1.w),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: TranslatedText(
                                  text: "delete_account",
                                  style: getTextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(
                                Icons.warning_amber,
                                size: 24.sp,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
