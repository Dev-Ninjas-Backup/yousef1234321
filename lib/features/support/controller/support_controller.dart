import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class ChatController extends GetxController {
  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;
  TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadInitialMessages();
  }

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

  navigateToIndividualChat(chat) {}
}
