import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';
import 'package:yousef1234321/routes/app_route.dart';

import '../widgets/delete_dialog.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(ProfileController());
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(title: "Profile"),
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(100),
                      child: Image.asset(
                        Imagepath.profile,
                        height: 96,
                        width: 96,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Leonardo",
                      style: getTextStyle(
                        fontSize: 24,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    Text(
                      "Leonardo@gmail.com",
                      style: getTextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFBDC6D3).withValues(alpha: .12),
                      blurRadius: 16,
                      spreadRadius: 0,
                      offset: Offset(0, 6),
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
                      spacing: 8,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  controller.profileItem[index].icon,
                                  size: 24,
                                ),
                                Text(
                                  controller.profileItem[index].title,
                                  style: getTextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: controller.profileItem[index].ontap,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: .8),
                        SizedBox(height: 4),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 30),

              Row(
                spacing: 12,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Approute.signInScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(color: Colors.transparent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Text(
                            "Log Out",
                            textAlign: TextAlign.center,

                            style: getTextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.logout_sharp,
                            size: 24,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showDeletelDialog();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          // color:Colors.amber,
                          border: Border.all(color: Colors.red, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          spacing: 4,
                          children: [
                            Text(
                              "Delete Account",
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),

                            Icon(
                              Icons.warning_amber,
                              size: 24,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
