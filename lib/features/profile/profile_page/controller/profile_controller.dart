import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yousef1234321/features/profile/profile_page/model/profile_model.dart';
import 'package:yousef1234321/routes/app_route.dart';

class ProfileController extends GetxController {
  var profileItem = [

    ProfileModel(
      icon: Icons.person_2_outlined,
      title: "Profile",
      ontap: () {
        Get.toNamed(Approute.editProfileScreen);
      },
    ),
    ProfileModel(icon: Icons.list, title: "My Listing"),
    ProfileModel(
      icon: Icons.location_on_outlined,
      title: "Location",
      ontap: () {
        Get.toNamed(Approute.locationPageScreen);
      },
    ),

    ProfileModel(icon: Icons.person_2_outlined, title: "Profile", ontap: () {}),
    ProfileModel(
      icon: Icons.list,
      title: "My Listing",
      ontap: () {
        Get.toNamed(Approute.myListingPage);
      },
    ),
    ProfileModel(icon: Icons.location_on_outlined, title: "Location"),

    ProfileModel(
      icon: Icons.directions,
      title: "Recent Garage",
      ontap: () {
        Get.toNamed(Approute.recentGaragePage);
      },
    ),
    ProfileModel(icon: Icons.settings, title: "App Settings"),
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
