// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/service_booking/model/garage_detail_model.dart';

class ServiceBookingController extends GetxController {
  final Rx<GarageDetailModel?> garageDetail = Rx<GarageDetailModel?>(null);
  final isLoading = false.obs;
  final hasError = false.obs;
  String? garageId;
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

    // Get garage ID from arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['garageId'] != null) {
      garageId = args['garageId'];
      fetchGarageDetails();
    }

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

  Future<void> fetchGarageDetails() async {
    if (garageId == null) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      print(
        'ServiceBookingController: Fetching garage details for ID: $garageId',
      );

      final response = await ApiClient.to.get(
        '${Endpoint.garageDetails}/$garageId',
      );

      print('ServiceBookingController: Response status=${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body['success'] == true && body['data'] != null) {
          garageDetail.value = GarageDetailModel.fromJson(body['data']);
          print(
            'ServiceBookingController: Garage details loaded: ${garageDetail.value?.name}',
          );

          // Update images with cover photo if available
          if (garageDetail.value?.coverPhoto != null &&
              garageDetail.value!.coverPhoto.isNotEmpty) {
            images.value = [garageDetail.value!.coverPhoto];
          }

          // Update services from API
          if (garageDetail.value?.services != null &&
              garageDetail.value!.services.isNotEmpty) {
            services.value = garageDetail.value!.services.map((serviceName) {
              return {
                "title": serviceName,
                "icon": _getServiceIcon(serviceName),
              };
            }).toList();
          }
        } else {
          print('ServiceBookingController: Invalid response structure');
          hasError.value = true;
        }
      } else {
        print(
          'ServiceBookingController: Failed with status ${response.statusCode}',
        );
        hasError.value = true;
      }
    } catch (e, stackTrace) {
      print('Failed to fetch garage details: $e');
      print('Stack trace: $stackTrace');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  String _getServiceIcon(String serviceName) {
    final lowerName = serviceName.toLowerCase().trim();

    print('Mapping service icon for: "$serviceName" (lowercase: "$lowerName")');

    // AC & Air Conditioning
    if (lowerName.contains('ac') ||
        lowerName.contains('air') ||
        lowerName.contains('conditioning') ||
        lowerName.contains('cooling')) {
      return Iconpath.acIcon;
    }
    // Battery
    else if (lowerName.contains('battery') || lowerName.contains('batteries')) {
      return Iconpath.batterryIcon;
    }
    // Tires & Wheels
    else if (lowerName.contains('tire') ||
        lowerName.contains('tyre') ||
        lowerName.contains('wheel')) {
      return Iconpath.tire;
    }
    // Engine
    else if (lowerName.contains('engine') ||
        lowerName.contains('motor') ||
        lowerName.contains('diagnostic')) {
      return Iconpath.engineIcon;
    }
    // Electrical
    else if (lowerName.contains('electric') ||
        lowerName.contains('wiring') ||
        lowerName.contains('lighting')) {
      return Iconpath.electricIcon;
    }
    // Brakes
    else if (lowerName.contains('brake') || lowerName.contains('braking')) {
      return Iconpath.tire; // Using tire icon for brakes as fallback
    }
    // Oil
    else if (lowerName.contains('oil') ||
        lowerName.contains('fluid') ||
        lowerName.contains('lubrication')) {
      return Iconpath.engineIcon; // Using engine icon for oil
    }
    // Spare parts
    else if (lowerName.contains('spare') || lowerName.contains('part')) {
      return Iconpath.spareIcon;
    }
    // Default - cycle through icons to avoid all being the same
    else {
      // Use hash of service name to pick different icons
      final hashCode = serviceName.hashCode.abs();
      final icons = [
        Iconpath.acIcon,
        Iconpath.batterryIcon,
        Iconpath.tire,
        Iconpath.engineIcon,
        Iconpath.electricIcon,
        Iconpath.spareIcon,
      ];
      final selectedIcon = icons[hashCode % icons.length];
      print(
        'Using fallback icon for "$serviceName": index ${hashCode % icons.length}',
      );
      return selectedIcon;
    }
  }
}
