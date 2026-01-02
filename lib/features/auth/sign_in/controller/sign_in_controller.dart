import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/routes/app_route.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> signIn({String? email, String? password}) async {
    if (isLoading.value) return;

    final emailValue = (email ?? emailController.text).trim();
    final passwordValue = (password ?? passwordController.text).trim();

    if (emailValue.isEmpty || passwordValue.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {'email': emailValue, 'password': passwordValue};

      final response = await ApiClient.to.post(Endpoint.login, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login response is nested inside "result"
        if (response.body != null &&
            response.body is Map &&
            response.body['result'] != null &&
            response.body['result']['data'] != null) {
          final resultData = response.body['result']['data'];
          String accessToken = resultData['token'] ?? "";
          String userId = resultData['user']['id'] ?? "";

          if (accessToken.isNotEmpty) {
            await ApiClient.to.setToken(accessToken);
            await ApiClient.to.setUserId(userId);

            Get.snackbar(
              "Success",
              "Login Successful",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Navigate to Home/Dashboard
            Get.offAllNamed(Approute.bottomNavBarScreen);
          } else {
            Get.snackbar(
              "Error",
              "Invalid token received",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Invalid response format",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Error",
          "Login failed with status code: ${response.statusCode}",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with Google. Requires google_sign_in package and backend endpoint
  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await googleSignIn.signIn();
      if (account == null) {
        // user canceled
        isLoading.value = false;
        return;
      }

      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;

      if (idToken == null) {
        Get.snackbar('Error', 'Failed to get id token from Google');
        return;
      }

      // Send token to backend for verification / login
      final body = {
        'provider': 'google',
        'idToken': idToken,
        if (accessToken != null) 'accessToken': accessToken,
      };

      final response = await ApiClient.to.post('/auth/social-login', body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final respBody = response.body;
        // Attempt to read token from common shapes
        String? token;
        String? userId;
        if (respBody is Map) {
          token =
              respBody['token']?.toString() ??
              respBody['data']?['token']?.toString();
          userId =
              respBody['data']?['user']?['id']?.toString() ??
              respBody['user']?['id']?.toString();
        }

        if (token != null && token.isNotEmpty) {
          await ApiClient.to.setToken(token);
          if (userId != null && userId.isNotEmpty) {
            await ApiClient.to.setUserId(userId);
          }
          Get.snackbar('Success', 'Signed in with Google');
          Get.offAllNamed(Approute.bottomNavBarScreen);
        } else {
          Get.snackbar('Error', 'Social login failed: invalid token');
        }
      } else {
        Get.snackbar('Error', 'Social login failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Google sign-in failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
