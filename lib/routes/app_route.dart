import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:yousef1234321/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:yousef1234321/features/onboarding/screen/onboarding_screen.dart';
import 'package:yousef1234321/features/splash/screen/splash_screen.dart';

class Approute {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String signInScreen = '/signInScreen';

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getSignInScreen() => signInScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(name: signInScreen, page: () => SignInScreen()),
  ];
}
