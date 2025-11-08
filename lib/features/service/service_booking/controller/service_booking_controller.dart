import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';

class ServiceBookingController extends GetxController {
  var images = [
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
  ].obs;

  var services = [
    {"title": "AC Service", "icon": Iconpath.acIcon},
    {"title": "Battery Replacement", "icon": Iconpath.batterryIcon},
    {"title": "Tires", "icon": Iconpath.tire},
    {"title": "Engine Diagnostics", "icon": Iconpath.engineIcon},
    {"title": "Electrical", "icon": Iconpath.electricIcon},
    {"title": "Spares", "icon": Iconpath.spareIcon},
  ].obs;
  var isOpen = true.obs;

  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    loadInitialMessages();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  //service msg

  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;
  TextEditingController textController = TextEditingController();

  void loadInitialMessages() {
    messages.addAll([
      {"text": "Hello!", "isUser": true, "time": "9:24"},
      {
        "text":
            "I’d like to service my car (Toyota Camry 2019). Are you available today?",
        "isUser": true,
        "time": "9:30",
      },
      {"text": "Hello!", "isUser": false, "time": "9:34"},
      {
        "text":
            "Hello! 👋 Yes, we have a few slots open this afternoon.\nWould you like to book an appointment at 3:00 PM?",
        "isUser": false,
        "time": "9:35",
      },
      {
        "text": "Yes, that works. Do you also offer oil change and inspection?",
        "isUser": true,
        "time": "9:39",
      },
    ]);

    Future.delayed(const Duration(seconds: 3), () {
      isTyping.value = true;
      Future.delayed(const Duration(seconds: 3), () {
        isTyping.value = false;
        messages.add({
          "text": "Yes, we offer full oil change and inspection packages!",
          "isUser": false,
          "time": "9:41",
        });
      });
    });
  }

  void sendMessage() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    final now = TimeOfDay.now();
    final formattedTime =
        "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')}";

    messages.add({"text": text, "isUser": true, "time": formattedTime});
    textController.clear();

    isTyping.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = false;
      messages.add({
        "text": "Got it! We'll get back to you shortly.",
        "isUser": false,
        "time": formattedTime,
      });
    });
  }
}
