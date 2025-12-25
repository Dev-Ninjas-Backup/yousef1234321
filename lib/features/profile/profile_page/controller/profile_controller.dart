// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/profile/profile_page/model/profile_model.dart';
import 'package:yousef1234321/routes/app_route.dart';

class ProfileController extends GetxController {
  var selectedIndex = (-1).obs;
  final isLoggingOut = false.obs;
  final isLoadingProfile = false.obs;

  // Profile data
  final fullName = ''.obs;
  final email = ''.obs;
  final profilePhoto = Rx<String?>(null);
  final phone = ''.obs;
  final role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoadingProfile.value = true;

      final response = await ApiClient.to.get(Endpoint.profile);

      print("Profile Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null &&
            response.body is Map &&
            response.body['data'] != null) {
          final data = response.body['data'];

          // Update profile data
          fullName.value = data['fullName'] ?? '';
          email.value = data['email'] ?? '';
          phone.value = data['phone'] ?? '';
          role.value = data['role'] ?? '';
          profilePhoto.value = data['profilePhoto']; // Can be null

          print("Profile loaded: ${fullName.value}, ${email.value}");
        } else {
          Get.snackbar(
            "Error",
            "Invalid profile data format",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Failed to load profile",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Profile fetch error: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch profile: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoadingProfile.value = false;
    }
  }

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
