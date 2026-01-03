// ignore_for_file: avoid_print

import 'dart:convert';
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
  final fullName = ''.obs;
  final email = ''.obs;
  final profilePhotoUrl = Rx<String?>(null);

  late final NetworkClient _networkClient;

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
    _networkClient = NetworkClient(onUnAuthorize: () {});

    // Pre-fill email from token immediately (Fix for "No email" issue)
    final tokenEmail = _getEmailFromToken();
    if (tokenEmail.isNotEmpty) {
      email.value = tokenEmail;
    }

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
          if (data['email'] != null && data['email'].toString().isNotEmpty) {
            email.value = data['email'];
          }
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
          // Load phone number as-is from API
          phoneController.text = (data['phone'] ?? '').toString();
        }
      } else if (response.statusCode == 404) {
        // This is expected for new users who haven't set up a profile yet.
        print(
          'EditProfileController: New user detected (404). Ready to create profile.',
        );
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

      // Use phone number as-is from the text field
      final phoneNumber = phoneController.text.trim();

      final extraFields = <String, String>{
        'fullName': combinedName,
        'bio': '',
        'phoneNumber': phoneNumber,
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
          'phoneNumber': phoneNumber,
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

  // Helper to extract email from JWT Token
  String _getEmailFromToken() {
    try {
      final token = ApiClient.to.token;
      if (token != null) {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final resp = utf8.decode(base64Url.decode(normalized));
          final payloadMap = jsonDecode(resp);
          if (payloadMap is Map && payloadMap['email'] != null) {
            return payloadMap['email'];
          }
        }
      }
    } catch (e) {
      print('Error decoding token: $e');
    }
    return '';
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
