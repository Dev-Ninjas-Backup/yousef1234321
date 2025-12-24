// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/service/network_service/network_client.dart';
import 'package:yousef1234321/features/profile/profile_page/controller/profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final emirateController = TextEditingController();

  final Rx<File?> selectedImage = Rx<File?>(null);
  final countryCode = '+880'.obs;
  final fullName = ''.obs;
  final email = ''.obs;
  final profilePhotoUrl = Rx<String?>(null);

  final NetworkClient _networkClient = NetworkClient(onUnAuthorize: () {});

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      print('EditProfileController: ApiClient token: ${ApiClient.to.token}');
      final response = await ApiClient.to.get(Endpoint.profile);
      print(
        'EditProfileController: profile GET status=${response.statusCode} body=${response.body}',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body is Map && body['data'] != null) {
          final data = body['data'];
          fullName.value = data['fullName'] ?? '';
          email.value = data['email'] ?? '';
          profilePhotoUrl.value = data['profilePhoto'];

          // Split full name into first and last
          final parts = (fullName.value).split(' ');
          if (parts.isNotEmpty) {
            firstNameController.text = parts.first;
            lastNameController.text = parts.length > 1
                ? parts.sublist(1).join(' ')
                : '';
          }

          // Populate other fields if available
          addressController.text = data['address'] ?? '';
          cityController.text = data['city'] ?? '';
          emirateController.text = data['emirate'] ?? '';
          final phoneStr = (data['phone'] ?? '').toString();
          if (phoneStr.startsWith('+')) {
            // Extract country code (1-4 digits) and local number
            final match = RegExp(r'^\+(\d{1,4})(\d+)$').firstMatch(phoneStr);
            if (match != null) {
              countryCode.value = '+${match.group(1)}';
              phoneController.text = match.group(2) ?? '';
            } else {
              // Fallback: keep whole string but attempt to strip leading +
              phoneController.text = phoneStr.replaceFirst('+', '');
            }
          } else {
            phoneController.text = phoneStr;
          }
        }
      }
    } catch (e, st) {
      print('Failed to load profile: $e');
      print(st);
    }
  }

  void saveProfile() {
    _submitProfile();
  }

  Future<void> _submitProfile() async {
    try {
      final combinedName =
          '${firstNameController.text.trim()} ${lastNameController.text.trim()}'
              .trim();

      // Build phone with selected country code if needed
      String phoneFull;
      final rawPhone = phoneController.text.trim();
      if (rawPhone.startsWith('+')) {
        phoneFull = rawPhone;
      } else {
        final local = rawPhone.replaceFirst(RegExp(r'^0+'), '');
        phoneFull = '${countryCode.value}$local';
      }

      final extraFields = <String, String>{
        'fullName': combinedName,
        'bio': '',
        'phoneNumber': phoneFull,
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'emirate': emirateController.text.trim(),
        'email': email.value,
      };

      // If user picked a new image, upload as multipart PATCH
      if (selectedImage.value != null) {
        final url = '${Endpoint.baseUrl}${Endpoint.editProfile}';
        final result = await _networkClient.uploadFile(
          url: url,
          file: selectedImage.value!,
          fieldName: 'file',
          extraFields: extraFields,
          method: 'PATCH',
        );

        if (result.isSuccess) {
          final respData = result.responseData;
          final data = respData != null && respData['data'] != null
              ? respData['data']
              : null;
          profilePhotoUrl.value = data != null
              ? data['profilePhoto']
              : profilePhotoUrl.value;
          Get.back();
          Get.snackbar(
            'Success',
            respData['message'] ?? 'Profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            result.errorMessage ?? 'Update failed',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        // No image: send JSON PATCH
        final url = '${Endpoint.baseUrl}${Endpoint.editProfile}';
        final body = {
          'fullName': combinedName,
          'bio': '',
          'phoneNumber': phoneFull,
          'address': addressController.text.trim(),
          'city': cityController.text.trim(),
          'emirate': emirateController.text.trim(),
          'email': email.value,
        };

        final result = await _networkClient.patchRequest(url: url, body: body);
        if (result.isSuccess) {
          final respData = result.responseData;
          final data = respData != null && respData['data'] != null
              ? respData['data']
              : null;
          profilePhotoUrl.value = data != null
              ? data['profilePhoto']
              : profilePhotoUrl.value;
          await profileController.fetchProfile();
          Get.back();
          Get.snackbar(
            'Success',
            respData['message'] ?? 'Profile updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            result.errorMessage ?? 'Update failed',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      print('Profile submit error: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();
    emirateController.dispose();
    super.onClose();
  }
}
