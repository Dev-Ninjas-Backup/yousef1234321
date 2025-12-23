import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/profile/profile_page/model/profile_model.dart';
import 'package:yousef1234321/routes/app_route.dart';

class ProfileController extends GetxController {
  var selectedIndex = (-1).obs;
  final isLoggingOut = false.obs;

  /// Logout user - clear tokens and navigate to sign in
  Future<void> logout() async {
    try {
      isLoggingOut.value = true;

      // Clear tokens from shared preferences
      await ApiClient.to.logout();

      // Show success message
      Get.snackbar(
        "Success",
        "Logged out successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to sign in screen and clear navigation stack
      Get.offAllNamed(Approute.signInScreen);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to logout: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  var profileItem = [
    ProfileModel(
      icon: Icons.person_2_outlined,
      title: "Profile",
      ontap: () {
        Get.toNamed(Approute.editProfileScreen);
      },
    ),
    ProfileModel(
      icon: Icons.list,
      title: "My Listing",
      ontap: () {
        Get.toNamed(Approute.myListingPage);
      },
    ),
    ProfileModel(
      icon: Icons.location_on_outlined,
      title: "Location",
      ontap: () {
        Get.toNamed(Approute.locationPageScreen);
      },
    ),
    ProfileModel(icon: Icons.settings, title: "App Settings"),

    ProfileModel(
      icon: Icons.language,
      title: "Language",
      ontap: () {
        Get.toNamed(Approute.languageScreen);
      },
    ),
    ProfileModel(
      icon: Icons.contact_support_rounded,
      title: "Help & Support",
      ontap: () {
        Get.toNamed(Approute.helpSupportScreen);
      },
    ),
    ProfileModel(icon: Icons.security, title: "Legal & Security"),
  ];
}
