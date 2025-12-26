import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/parts_details/model.dart/part_categories_model.dart';

class PartsDetailsController extends GetxController {
  /// ---------------- Text Controllers ----------------
  final partNameCtrl = TextEditingController();
  final partNumberCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final sellerNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final brand = TextEditingController();
  final quantity = TextEditingController();

  /// ---------------- Dropdown Values ----------------
 // final category = ''.obs;
  // final brand = ''.obs;
  // final quantity = ''.obs;

  /// ---------------- Listing Plan ----------------
  final selectedPlan = 0.obs; // 0 = Monthly, 1 = Pay per listing

  void selectPlan(int value) {
    selectedPlan.value = value;
  }

  /// ---------------- Promotion ----------------
  final isPromoted = false.obs;

  void togglePromotion(bool value) {
    isPromoted.value = value;
  }

  /// ---------------- Image ----------------
  final selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = image;
    }
  }

  /// ---------------- Confirmation ----------------
  final isConfirmed = false.obs;
  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }


  var selectedCategoryId = RxnString();

  var categories = <PartCategory>[].obs;
    var isLoadingCategories = false.obs;
  var errorMessageCategories = ''.obs;

  Future<void> fetchCategories() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${ApiClient.to.resetToken}',
      };

      final response = await http.get(
        Uri.parse("${Endpoint.baseUrl}/parts-category"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          List<dynamic> dataList = jsonData['data']['data'];
          categories.value = dataList
              .map((e) => PartCategory.fromJson(e))
              .toList();
        } else {
          print("Error");
        }
      } else {}
    } catch (e) {
    } finally {}
  }

  @override
  void onClose() {
    partNameCtrl.dispose();
    partNumberCtrl.dispose();
    priceCtrl.dispose();
    descriptionCtrl.dispose();
    sellerNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    brand.dispose();
    quantity.dispose();
    super.onClose();
  }
}
