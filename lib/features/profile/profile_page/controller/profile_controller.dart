import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yousef1234321/features/profile/profile_page/model/profile_model.dart';

class ProfileController extends GetxController {
  var profileItem = [
    ProfileModel(icon: Icons.person_2_outlined, title: "Profile",ontap: (){}),
    ProfileModel(icon: Icons.list, title: "My Listing"),
    ProfileModel(icon: Icons.location_on_outlined, title: "Location"),
    ProfileModel(icon: Icons.directions, title: "Recent Garage"),
    ProfileModel(icon: Icons.settings, title: "App Settings"),
    ProfileModel(icon: Icons.contact_support_rounded, title: "Help & Support"),
    ProfileModel(icon: Icons.security, title: "Legal & Security"),
  ];
}
