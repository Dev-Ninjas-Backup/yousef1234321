// ignore_for_file: avoid_print

import 'dart:async';
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
import 'package:http_parser/http_parser.dart';

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
        final url = data['url'] as String?;
        if (url != null && url.isNotEmpty) {
          await _openPaymentAndPoll(url, expectMonthly: true);
        } else {
          EasyLoading.showError("Payment failed: invalid payment url");
        }
      } else {
        print("monthly response:${response.body}");
        final msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : "Payment failed";
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong: $e");
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
        final url = data['url'] as String?;
        if (url != null && url.isNotEmpty) {
          await _openPaymentAndPoll(url, expectProductCredits: true);
        } else {
          EasyLoading.showError("Payment failed: invalid payment url");
        }
      } else {
        final msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : "Payment failed";
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong: $e");
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
        final url = data['url'] as String?;
        if (url != null && url.isNotEmpty) {
          await _openPaymentAndPoll(url, expectPromotionCredit: true);
        } else {
          EasyLoading.showError("Payment failed: invalid payment url");
        }
      } else {
        final msg = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : "Payment failed";
        EasyLoading.showError(msg);
      }
    } catch (e) {
      EasyLoading.showError("Something went wrong: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> _openPaymentAndPoll(
    String url, {
    bool expectMonthly = false,
    bool expectProductCredits = false,
    bool expectPromotionCredit = false,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    try {
      // Snapshot previous values
      final prevHasMonthly = hasProductMonthly.value;
      final prevProductCredits = productCredits.value;
      final prevPromotionCredits = promotionCredits.value;
      final prevCanAddFree = canAddFreeProduct.value;

      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);

      // Start polling the server for up to [timeout]
      final start = DateTime.now();
      final completer = Completer<void>();
      final timer = Timer.periodic(const Duration(seconds: 5), (t) async {
        try {
          await checkUserProductLimit();

          final nowHasMonthly = hasProductMonthly.value;
          final nowProductCredits = productCredits.value;
          final nowPromotionCredits = promotionCredits.value;
          final nowCanAddFree = canAddFreeProduct.value;

          var confirmed = false;
          if (expectMonthly && nowHasMonthly && nowHasMonthly != prevHasMonthly)
            confirmed = true;
          if (expectProductCredits && nowProductCredits > prevProductCredits)
            confirmed = true;
          if (expectPromotionCredit &&
              nowPromotionCredits > prevPromotionCredits)
            confirmed = true;
          if (nowCanAddFree && nowCanAddFree != prevCanAddFree)
            confirmed = true;

          if (confirmed) {
            EasyLoading.showSuccess('Payment confirmed');
            t.cancel();
            completer.complete();
            return;
          }

          if (DateTime.now().difference(start) > timeout) {
            t.cancel();
            // timeout — don't treat as failure of payment, inform the user
            EasyLoading.showInfo(
              'Payment not yet confirmed. Refreshing status later.',
            );
            completer.complete();
            return;
          }
        } catch (e) {
          // ignore polling errors
        }
      });

      await completer.future;
      // Ensure we have the latest state from server after polling completes
      try {
        await checkUserProductLimit();
      } catch (_) {}
      if (timer.isActive) timer.cancel();
    } catch (e) {
      EasyLoading.showError('Failed to open payment');
    }
  }

  final hasProductMonthly = false.obs;
  final productMonthlyEndsAt = Rxn<DateTime>();
  final productCredits = 0.obs;
  final canAddFreeProduct = false.obs;
  final promotionCredits = 0.obs;

  Future<void> handlePromotionPayment() async {
    if (promotionCredits.value > 0) {
      EasyLoading.showSuccess(
        "Promotion applied using credit (${promotionCredits.value} left)",
      );

      // Optional: decrease locally for instant UI feedback
      promotionCredits.value -= 1;
      return;
    }

    await createPromotionPayment();
  }

  Future<bool> validatePromotionBeforeSubmit() async {
    if (!isPromoted.value) return true;

    // Refresh server state before deciding - ensures we don't rely on stale local value
    await checkUserProductLimit();

    if (promotionCredits.value > 0) {
      // Consume one credit locally for immediate UX feedback. The server will reconcile on createProduct.
      promotionCredits.value = promotionCredits.value - 1;
      return true;
    }

    // No credits available: open payment flow for buying a promotion credit
    await createPromotionPayment();
    return false;
  }

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

  /// ---------------- Promotion ----------------
  final isPromoted = false.obs;

  void togglePromotion(bool value) {
    isPromoted.value = value;
  }

  /// ---------------- Image ----------------
  // final selectedImage = Rx<XFile?>(null);
  // final ImagePicker _picker = ImagePicker();

  // Future<void> pickImage() async {
  //   final image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     selectedImage.value = image;
  //   }
  // }
  final selectedImages = <XFile>[].obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      selectedImages.addAll(images); // allow adding more images
    }
  }

  /// Remove image by index
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
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
        'Authorization': 'Bearer ${ApiClient.to.token}',
      };

      final response = await http.get(
        Uri.parse("${Endpoint.baseUrl}/parts-category"),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData['success'] == true) {
          List<dynamic> dataList = jsonData['data']['data'];
          categories.value = dataList
              .map((e) => PartCategory.fromJson(e))
              .toList();

          print("the categoris: ${response.body}");
        } else {
          print("Error");
        }
      } else {}
    } catch (e) {
      print(e);
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

  Future<void> createProduct() async {
    try {
      EasyLoading.show(status: "Creating listing...");

      // ---------- VALIDATION ----------
      if (partNameCtrl.text.isEmpty ||
          brand.text.isEmpty ||
          selectedCategoryId.value == null ||
          priceCtrl.text.isEmpty ||
          quantity.text.isEmpty ||
          sellerNameCtrl.text.isEmpty ||
          phoneCtrl.text.isEmpty) {
        EasyLoading.showError("Please fill all required fields");
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Endpoint.baseUrl}/products"),
      );

      // ---------- ADD FIELDS ----------
      request.headers['Authorization'] = 'Bearer ${ApiClient.to.token}';
      request.fields.addAll({
        "partName": partNameCtrl.text.trim(),
        "brand": brand.text.trim(),
        "categoryId": selectedCategoryId.value!,
        "condition": "New",
        "price": priceCtrl.text,
        "quantity": quantity.text,
        "description": descriptionCtrl.text.trim(),
        "isPromoted": isPromoted.value.toString(),
        "sellerName": sellerNameCtrl.text.trim(),
        "sellerEmail": emailCtrl.text.trim(),
        "sellerPhoneNumber": phoneCtrl.text.trim(),
        "sellerType": "INDIVIDUAL",
        "plan": selectedPlan.value == 0 ? "MONTHLY" : "PAY_PER",
      });

      // ---------- ADD MULTIPLE IMAGES ----------
      for (var img in selectedImages) {
        final mimeType = img.path.split('.').last.toLowerCase();

        String type;
        String subtype;

        switch (mimeType) {
          case 'jpg':
          case 'jpeg':
            type = 'image';
            subtype = 'jpeg';
            break;
          case 'png':
            type = 'image';
            subtype = 'png';
            break;
          default:
            type = 'application';
            subtype = 'octet-stream';
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'photos', // key expected by your API
            img.path,
            contentType: MediaType(type, subtype),
          ),
        );
      }

      // ---------- SEND REQUEST ----------
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Product listed successfully 🎉");
        await checkUserProductLimit();
        Get.back();
      } else {
        debugPrint("Create product error: ${response.body}");
        String serverMsg = "Failed to create product";
        try {
          final data = json.decode(response.body);
          if (data is Map) {
            serverMsg =
                data['message']?.toString() ??
                data['error']?.toString() ??
                data['errorMessage']?.toString() ??
                serverMsg;
          }
        } catch (_) {}
        EasyLoading.showError(serverMsg);
      }
    } catch (e) {
      debugPrint("Create product exception: $e");
      EasyLoading.showError("Something went wrong: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Future<void> createProduct() async {
  //   try {
  //     EasyLoading.show(status: "Creating listing...");

  //     // ---------- VALIDATION ----------
  //     if (partNameCtrl.text.isEmpty ||
  //         brand.text.isEmpty ||
  //         selectedCategoryId.value == null ||
  //         priceCtrl.text.isEmpty ||
  //         quantity.text.isEmpty ||
  //         sellerNameCtrl.text.isEmpty ||
  //         phoneCtrl.text.isEmpty) {
  //       EasyLoading.showError("Please fill all required fields");
  //       return;
  //     }

  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse("${Endpoint.baseUrl}/products"),
  //     );

  //     // ---------- ADD FIELDS ----------
  //     request.headers['Authorization'] = 'Bearer ${ApiClient.to.token}';
  //     request.fields['partName'] = partNameCtrl.text.trim();
  //     request.fields['brand'] = brand.text.trim();
  //     request.fields['categoryId'] = selectedCategoryId.value!;
  //     request.fields['condition'] = 'New';
  //     request.fields['price'] = priceCtrl.text;
  //     request.fields['quantity'] = quantity.text;
  //     request.fields['description'] = descriptionCtrl.text.trim();
  //     request.fields['isPromoted'] = isPromoted.value.toString();
  //     request.fields['sellerName'] = sellerNameCtrl.text.trim();
  //     request.fields['sellerEmail'] = emailCtrl.text.trim();
  //     request.fields['sellerPhoneNumber'] = phoneCtrl.text.trim();
  //     request.fields['sellerType'] = 'INDIVIDUAL';
  //     request.fields['plan'] = selectedPlan.value == 0 ? 'MONTHLY' : 'PAY_PER_LISTING';

  //     // ---------- ADD IMAGE ----------
  // if (selectedImage.value != null) {
  //   final mimeType = selectedImage.value!.path.split('.').last.toLowerCase();

  //   String type;
  //   String subtype;

  //   switch (mimeType) {
  //     case 'jpg':
  //     case 'jpeg':
  //       type = 'image';
  //       subtype = 'jpeg';
  //       break;
  //     case 'png':
  //       type = 'image';
  //       subtype = 'png';
  //       break;
  //     default:
  //       type = 'application';
  //       subtype = 'octet-stream';
  //   }

  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'photos', // key expected by your API
  //       selectedImage.value!.path,
  //       contentType: MediaType(type, subtype),
  //     ),
  //   );
  // }

  //     // ---------- SEND REQUEST ----------
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       EasyLoading.showSuccess("Product listed successfully 🎉");

  //       // Refresh limits
  //       await checkUserProductLimit();

  //       Get.back();
  //     } else {
  //       debugPrint("Create product error: ${response.body}");
  //       EasyLoading.showError("Failed to create product");
  //     }
  //   } catch (e) {
  //     debugPrint("Create product exception: $e");
  //     EasyLoading.showError("Something went wrong");
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }
}
