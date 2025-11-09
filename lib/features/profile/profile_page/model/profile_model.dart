import 'package:flutter/widgets.dart';

class ProfileModel {
  final IconData icon;
  final String title;
  final VoidCallback? ontap;

  ProfileModel({required this.icon, required this.title, this.ontap});
}
