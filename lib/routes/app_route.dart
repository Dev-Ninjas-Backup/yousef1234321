import 'package:get/get_navigation/get_navigation.dart';
import 'package:yousef1234321/features/splash/screen/splash_screen.dart';

class Approute {
  static String splashScreen = '/splashScreen';
  static String getSplashScreen() => splashScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
  ];
}
