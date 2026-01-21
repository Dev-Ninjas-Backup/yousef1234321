// service_review_controller.dart
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/endpoint/endpoint.dart';

class ServiceReviewController extends GetxController {
  // Star Ratings
  var overallRating = 0.obs;
  var serviceQualityRating = 0.obs;
  var timelinessRating = 0.obs;
  var valueForMoneyRating = 0.obs;

  // Feedback Text
  final feedbackController = TextEditingController();

  void setRating(String type, int value) {
    switch (type) {
      case 'overall':
        overallRating.value = value;
        break;
      case 'quality':
        serviceQualityRating.value = value;
        break;
      case 'timeliness':
        timelinessRating.value = value;
        break;
      case 'value':
        valueForMoneyRating.value = value;
        break;
    }
  }

  final ImagePicker _picker = ImagePicker();
  final Rxn<File> image = Rxn<File>();
  // Recommendation toggle (true = recommended)
  var recommendation = false.obs;

  // Submission state
  var isSubmitting = false.obs;

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image.value = File(pickedFile.path);
    }
  }

  void removeImage() {
    image.value = null;
  }

  void submitReview() {
    if (overallRating.value == 0 ||
        serviceQualityRating.value == 0 ||
        timelinessRating.value == 0 ||
        valueForMoneyRating.value == 0) {
      EasyLoading.showToast("incomplete_rating".tr);
      return;
    }
    _submitToServer();
  }

  Future<void> _submitToServer() async {
    final args = Get.arguments as Map<String, dynamic>?;
    // Accept numeric or string garageId; convert to string safely
    final dynamic rawGarageId = args != null ? args['garageId'] : null;
    final String? garageId = rawGarageId?.toString();
    if (garageId == null || garageId.isEmpty) {
      EasyLoading.showError('garage_id_not_found'.tr);
      return;
    }

    final body = {
      'overallExperience': overallRating.value,
      'serviceQuality': serviceQualityRating.value,
      'timeliness': timelinessRating.value,
      'valueForMoney': valueForMoneyRating.value,
      'comment': feedbackController.text.trim(),
      'recommendation': recommendation.value,
      'photos': <String>[], // no upload endpoint currently; send empty list
    };

    try {
      isSubmitting.value = true;
      // Debug: log request body
      print('Posting review to: ${Endpoint.postReview}/$garageId');
      print('Review request body: $body');

      final res = await ApiClient.to.post(
        '${Endpoint.postReview}/$garageId',
        body,
      );

      // Debug: log full response
      print('Review POST response: ${res.statusCode}');
      print('Review POST response body: ${res.bodyString}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Some backends return 200 with an error payload. Inspect body for explicit error markers.
        bool backendOk = true;
        final respBody = res.body;
        if (respBody is Map<String, dynamic>) {
          if (respBody.containsKey('success') && respBody['success'] == false) {
            backendOk = false;
          }
          if (respBody.containsKey('status') && respBody['status'] == 'error') {
            backendOk = false;
          }
          if (respBody.containsKey('error')) {
            backendOk = false;
          }
        }

        if (!backendOk) {
          print(
            'Backend reported error when creating review: ${res.bodyString}',
          );
          EasyLoading.showError('failed_submit_review'.tr);
          EasyLoading.showError('submit_review_failed'.tr);
        } else {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.green.shade100,
                      child: Icon(
                        Icons.check_circle_outline,
                        color: Colors.green.shade700,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'thank_you'.tr,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'feedback_submitted_successfully'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            barrierDismissible: false,
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (Get.isDialogOpen == true) Get.back();
          });

          EasyLoading.showSuccess('review_submitted'.tr);
          resetForm();
          // Go back to previous screen
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.back();
          });
        }
      } else {
        print('Failed to post review: ${res.statusCode} ${res.bodyString}');
        EasyLoading.showError('failed_submit_review'.tr);
        EasyLoading.showError('submit_review_failed'.tr);
      }
    } catch (e, st) {
      print('Error submitting review: $e');
      print(st);
      EasyLoading.showError('failed_submit_review'.tr);
      EasyLoading.showError('submit_review_failed'.tr);
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    overallRating.value = 0;
    serviceQualityRating.value = 0;
    timelinessRating.value = 0;
    valueForMoneyRating.value = 0;
    feedbackController.clear();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}
