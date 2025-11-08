//import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SparePartsController extends GetxController {
  var selectedModel = RxnString();
  var selectedCategory = RxnString();

  // final ScrollController scrollController = ScrollController();
  // late Timer timer;

  // double speed = 1.0;

  // startScroll() {
  //   timer = Timer.periodic(const Duration(milliseconds: 16), (t) {
  //     if (scrollController.hasClients) {
  //       scrollController.jumpTo(scrollController.offset + speed);

  //       if (scrollController.offset >=
  //           scrollController.position.maxScrollExtent) {
  //         scrollController.jumpTo(0);
  //       }
  //     }
  //   });
  // }

  // @override
  // void onInit() {
  //   super.onInit();
  //   startScroll();
  // }

  // @override
  // void onClose() {
  //   timer.cancel();
  //   scrollController.dispose();
  //   super.onClose();
  // }

  final models = [
    "AC Repair",
    "Battery",
    "Engine",
    "Tires",
    "Electrical",
    "Spares",
    "Brakes",
    "Body Work",
  ];

  final dropDownCategories = ["Dubai", "Abu Dhabi", "Sharjah", "Ajman"];

  final categories = [
    {'name': 'Engine', 'icon': Icons.settings},
    {'name': 'Body', 'icon': Icons.directions_car},
    {'name': 'Brakes', 'icon': Icons.speed},
    {'name': 'Electric', 'icon': Icons.bolt},
    {'name': 'Fluids', 'icon': Icons.water_drop},
    {'name': 'Tools', 'icon': Icons.build},
    {'name': 'Safety', 'icon': Icons.security},
    {'name': 'More', 'icon': Icons.more_horiz},
  ];

  final allParts = [
    {
      'name': 'Brake Pads',
      'desc': 'Premium Quality',
      'price': 89.99,
      'rating': 4.8,
      'image':
          'https://dealer26407.dealeron.com/blogs/6087/wp-content/uploads/2024/10/car-parts-1024x683.jpg',
    },
    {
      'name': 'Oil Filter',
      'desc': 'OEM Standard',
      'price': 24.99,
      'rating': 4.9,
      'image':
          'https://dealer26407.dealeron.com/blogs/6087/wp-content/uploads/2024/10/car-parts-1024x683.jpg',
    },
  ];

  final random = Random();

  Color getRandomColor() {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.red.shade100,
      Colors.yellow.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
      Colors.teal.shade100,
      Colors.grey.shade200,
    ];
    return colors[random.nextInt(colors.length)];
  }
}
