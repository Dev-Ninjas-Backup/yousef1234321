import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/bottom_navbar/screen/bottom_navbar_screen.dart';

class SocialAuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Triggered when user clicks "Continue with Google"
  Future<void> signInWithGoogle() async {
    try {
      print("🔵 [SocialAuth] Starting Google Sign In...");
      // 1. Trigger the Google Authentication flow (Shows Gmail accounts)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("🟡 [SocialAuth] User canceled sign in");
        // User canceled the sign-in
        return;
      }

      EasyLoading.show(status: 'Signing in...');

      // 2. Obtain the auth details (idToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      print("🔵 [SocialAuth] Google ID Token obtained: ${idToken != null}");

      if (idToken != null) {
        // 3. Send the idToken to your backend
        await _backendGoogleLogin(idToken);
      } else {
        EasyLoading.showError('Failed to retrieve Google ID Token');
        print("🔴 [SocialAuth] ID Token is null");
      }
    } catch (error) {
      EasyLoading.dismiss();
      EasyLoading.showError('Google Sign In Failed');
      print("🔴 [SocialAuth] Error: $error");
    }
  }

  Future<void> _backendGoogleLogin(String idToken) async {
    try {
      print(
        "🔵 [SocialAuth] Sending ID Token to backend: ${Endpoint.googleLogin}",
      );
      final response = await ApiClient.to.post(Endpoint.googleLogin, {
        'idToken': idToken,
      });
      print(
        "🔵 [SocialAuth] Backend Response: ${response.statusCode} ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null) {
          String? token;
          dynamic userData;

          if (body is Map && body['data'] is Map) {
            token = body['data']['accessToken'] ?? body['data']['token'];
            userData = body['data']['user'];
          } else if (body is Map) {
            token = body['accessToken'] ?? body['token'];
            userData = body['user'];
          }

          if (token != null) {
            await ApiClient.to.setToken(token);
            if (userData is Map && userData['id'] != null) {
              await ApiClient.to.setUserId(userData['id'].toString());
            }

            EasyLoading.showSuccess('Login Successful');
            Get.offAll(() => BottomNavbarScreen());
          } else {
            EasyLoading.showError('Token not found in response');
            print("🔴 [SocialAuth] Token parsing failed. Body: $body");
          }
        }
      } else {
        // ApiClient handles global errors, but we can ensure loader is dismissed
        if (EasyLoading.isShow) EasyLoading.dismiss();
        print("🔴 [SocialAuth] API Error: ${response.statusText}");
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Connection failed');
      print("🔴 [SocialAuth] Exception: $e");
    }
  }
}
