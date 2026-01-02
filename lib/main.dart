import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yousef1234321/app.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/notification/controller/notification_controller.dart';
import 'package:yousef1234321/features/profile/language/controller/language_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences & ApiClient
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences, permanent: true);
  Get.put<ApiClient>(ApiClient(sharedPreferences: Get.find()), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Get.put(LanguageController(), permanent: true);

  configEasyLoading();
  runApp(const MyApp());
}

void configEasyLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.grey
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..maskColor = Colors.green
    ..userInteractions = false
    ..dismissOnTap = false;
}
