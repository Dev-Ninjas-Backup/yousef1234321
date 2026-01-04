// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  var profileItem = <ProfileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
    updateProfileItems();
  }

  void updateProfileItems() {
    profileItem.value = [
      ProfileModel(
        icon: Icons.person_2_outlined,
        title: "edit_profile",
        ontap: () {
          Get.toNamed(Approute.editProfileScreen);
        },
      ),
      ProfileModel(
        icon: Icons.list,
        title: "my_listing",
        ontap: () {
          Get.toNamed(Approute.myListingPage);
        },
      ),
      ProfileModel(
        icon: Icons.location_on_outlined,
        title: "location",
        ontap: () {
          Get.toNamed(Approute.locationPageScreen);
        },
      ),
      ProfileModel(icon: Icons.settings, title: "app_settings"),
      ProfileModel(
        icon: Icons.language,
        title: "language",
        ontap: () {
          Get.toNamed(Approute.languageScreen);
        },
      ),
      ProfileModel(
        icon: Icons.contact_support_rounded,
        title: "help_support",
        ontap: () {
          Get.toNamed(Approute.helpSupportScreen);
        },
      ),
      ProfileModel(icon: Icons.security, title: "legal_security"),
    ];
  }

  /// Fetch user profile from API
  Future<void> fetchProfile() async {
    try {
      isLoadingProfile.value = true;

      final response = await ApiClient.to.get(Endpoint.profile);

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
        } else {
          Get.snackbar(
            'error'.tr,
            'invalid_profile_data_format'.tr,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'error'.tr,
          'failed_to_load_profile'.tr,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_fetch_profile'.tr.replaceAll('@error', e.toString()),
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
        'success'.tr,
        'logged_out_successfully'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to sign in screen and clear navigation stack
      Get.offAllNamed(Approute.signInScreen);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'failed_to_logout'.tr.replaceAll('@error', e.toString()),
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
    ProfileModel(
      icon: Icons.settings,
      title: "App Settings",
      ontap: () {
        EasyLoading.showInfo("App Settings not available at the moment");
      },
    ),

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
    ProfileModel(
      icon: Icons.security,
      title: "Legal & Security",
      ontap: () {
        EasyLoading.showInfo("Legal & Security not available at the moment");
      },
    ),
  ];
}
