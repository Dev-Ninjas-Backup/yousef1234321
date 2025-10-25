import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:yousef1234321/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:yousef1234321/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:yousef1234321/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:yousef1234321/features/onboarding/screen/onboarding_screen.dart';
import 'package:yousef1234321/features/splash/screen/splash_screen.dart';

class Approute {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String signInScreen = '/signInScreen';
  static String signUpScreen = '/signUpScreen';
  static String forgetPasswordScreen = '/forgetPasswordScreen';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getSignInScreen() => signInScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getForgetPasswordScreen() => forgetPasswordScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: forgetPasswordScreen, page: () => ForgetPasswordScreen()),
  ];
}
