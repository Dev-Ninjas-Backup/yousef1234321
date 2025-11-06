import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/features/service/service%20page/model/service_model.dart';

import '../../../../core/common/constants/imagepath.dart';

class ServiceController extends GetxController {
  final searchController = TextEditingController();
  var serviceItemList = [].obs;

  var selectedOption = RxString('');

  final List<String> options = ["Garage Services ", "Towing Service "];

  void changeOption(String value) {
    selectedOption.value = value;
  }

  @override
  void onInit() {
    serviceItem();
    super.onInit();
  }

  void serviceItem() {
    serviceItemList.addAll([
      ServiceModel(
        imageUrl: Imagepath.onboarding1,
        title: "Al Majid Auto Service ",
        rating: 4.5,
        distance: 0.3,
        serviceItem: "AC • Engine • Brakes",
        totalReview: 127,
      ),

      ServiceModel(
        imageUrl: Imagepath.onboarding1,
        title: "Emirates Auto Care",
        rating: 4.5,
        distance: 0.3,
        serviceItem: "AC • Engine • Brakes",
        totalReview: 127,
      ),

      ServiceModel(
        imageUrl: Imagepath.onboarding1,
        title: "Al Majid Auto Service ",
        rating: 4.5,
        distance: 0.3,
        serviceItem: "AC • Engine • Brakes",
        totalReview: 127,
      ),

      ServiceModel(
        imageUrl: Imagepath.onboarding1,
        title: "Al Futtaim Auto Center",
        rating: 4.5,
        distance: 0.3,
        serviceItem: "AC • Engine • Brakes",
        totalReview: 127,
      ),

      ServiceModel(
        imageUrl: Imagepath.onboarding1,
        title: "Emirates Motor Works",
        rating: 4.5,
        distance: 0.3,
        serviceItem: "AC • Engine • Brakes",
        totalReview: 127,
      ),
    ]);
  }
}
