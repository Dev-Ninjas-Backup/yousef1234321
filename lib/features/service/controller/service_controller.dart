import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  final searchController = TextEditingController();

  var selectedOption = RxString('');

  final List<String> options = ["Garage Services ", "Towing Service "];

  void changeOption(String value) {
    selectedOption.value = value;
  }
}
