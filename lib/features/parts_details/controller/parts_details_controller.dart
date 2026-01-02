// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  // final isMonthlyPaid = false.obs;

  /// ---------------- MONTHLY PAYMENT ----------------
  Future<void> createMonthlyPayment() async {
    try {
      EasyLoading.show(status: "Redirecting to payment...");

      final response = await http.post(
        Uri.parse("${Endpoint.baseUrl}/products/create-monthly-payment"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiClient.to.token}',
        },
      );

      final data = json.decode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        print("monthly payment: ${data['url']}");
        final uri = Uri.parse(data['url']);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print("monthly response:${response.body}");
        EasyLoading.showError("Payment failed");
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// ---------------- PAY PER LISTING ----------------
  Future<void> createPayPerListingPayment() async {
    try {
      EasyLoading.show(status: "Redirecting to payment...");

      final response = await http.post(
        Uri.parse("${Endpoint.baseUrl}/products/create-payper-payment"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiClient.to.token}',
        },
      );

      final data = json.decode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        final uri = Uri.parse(data['url']);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        EasyLoading.showError("Payment failed");
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> createPromotionPayment() async {
    try {
      EasyLoading.show(status: "Redirecting to payment...");

      final response = await http.post(
        Uri.parse("${Endpoint.baseUrl}/products/create-promotion-payment"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiClient.to.token}',
        },
      );

      final data = json.decode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        final uri = Uri.parse(data['url']);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        EasyLoading.showError("Payment failed");
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong");
    } finally {
      EasyLoading.dismiss();
    }
  }

  final hasProductMonthly = false.obs;
  final productMonthlyEndsAt = Rxn<DateTime>();
  final productCredits = 0.obs;
  final canAddFreeProduct = false.obs;
  final promotionCredits = 0.obs;

  Future<void> checkUserProductLimit() async {
    try {
      final response = await http.get(
        Uri.parse("${Endpoint.baseUrl}/products/user/limit"),
        headers: {
          'Authorization': 'Bearer ${ApiClient.to.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        hasProductMonthly.value = data['hasProductMonthly'] == true;
        canAddFreeProduct.value = data['canAddFreeProduct'] == true;
        productCredits.value = data['productCredits'] ?? 0;
        promotionCredits.value = data['promotionCredits'] ?? 0;

        if (data['productMonthlyEndsAt'] != null) {
          productMonthlyEndsAt.value = DateTime.parse(
            data['productMonthlyEndsAt'],
          );
        }
      }
    } catch (e) {
      debugPrint("Limit check error: $e");
    }
  }

  void selectPlan(int value) {
    selectedPlan.value = value;
  }

  // void markMonthlyPaid() {
  //   isMonthlyPaid.value = true;
  // }

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
    checkUserProductLimit();
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
