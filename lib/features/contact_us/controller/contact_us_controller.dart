import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class ContactUsController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  final isLoadingProfile = false.obs;
  final isSending = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    // Try to fetch logged-in user profile and autofill name/email
    try {
      isLoadingProfile.value = true;

      final response = await ApiClient.to.get(Endpoint.profile);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body != null &&
            response.body is Map &&
            response.body['data'] != null) {
          final data = response.body['data'];
          final fullName = (data['fullName'] ?? '').toString();
          final email = (data['email'] ?? '').toString();

          // Split fullName into first and last (best-effort)
          String firstName = fullName;
          String lastName = '';
          if (fullName.trim().contains(' ')) {
            final parts = fullName.trim().split(RegExp(r'\s+'));
            firstName = parts.first;
            lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
          }

          nameController.text = [
            firstName,
            lastName,
          ].where((s) => s.isNotEmpty).join(' ');
          emailController.text = email;
        }
      }
    } catch (e) {
      // ignore errors — leave fields empty
    } finally {
      isLoadingProfile.value = false;
    }
  }

  /// Send contact message to API
  Future<void> sendMessage() async {
    if (isSending.value) return;

    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();

    if (fullName.isEmpty || email.isEmpty || message.isEmpty) {
      EasyLoading.showError('Please fill all fields before sending.');
      return;
    }

    // Best-effort split first/last name. Ensure LastName is not empty to satisfy API validation.
    String firstName = fullName;
    String lastName = '';
    if (fullName.contains(' ')) {
      final parts = fullName.split(RegExp(r'\s+'));
      firstName = parts.first;
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    }
    // If API requires LastName non-empty, fallback to duplicating firstName to avoid validation error.
    if (lastName.trim().isEmpty) {
      lastName = firstName;
    }

    isSending.value = true;
    try {
      final body = {
        'FirstName': firstName,
        'LastName': lastName,
        'email': email,
        'subject': 'CAR_PARTS', // default subject — change if you add UI
        'message': message,
      };

      final response = await ApiClient.to.post(Endpoint.contactUs, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Your message has been sent to ADMIN!');
        messageController.clear();
      } else {
        String err = 'Failed to send message';
        if (response.body is Map && response.body['message'] != null) {
          final msg = response.body['message'];
          if (msg is String) {
            err = msg;
          } else if (msg is List) {
            // join list entries into a single string
            err = msg.map((e) => e.toString()).join(', ');
          } else {
            err = msg.toString();
          }
        } else if (response.statusText != null) {
          err = response.statusText!;
        }
        Get.snackbar(
          'Error',
          err,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      EasyLoading.showError('Something went wrong: $e');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
