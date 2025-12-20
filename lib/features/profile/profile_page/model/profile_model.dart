import 'package:flutter/material.dart';

class ProfileModel {
  final IconData icon;
  final String title;
  final VoidCallback? ontap;
  final List<String>? languages;

  ProfileModel({
    required this.icon,
    required this.title,
    this.ontap,
    this.languages,
  });
}
