import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:yousef1234321/features/auth/forget_password/reset_password/reset_password_screen.dart';
import 'package:yousef1234321/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:yousef1234321/features/auth/sign_in/binding/sign_in_binding.dart';
import 'package:yousef1234321/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:yousef1234321/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/screen/otp_screen.dart';
import 'package:yousef1234321/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:yousef1234321/features/contact_us/screen/contact_us_screen.dart';
import 'package:yousef1234321/features/help_support/screen/help_support_screen.dart';
import 'package:yousef1234321/features/home/garage_list/screen/garage_list_screen.dart';
import 'package:yousef1234321/features/onboarding/screen/onboarding_screen.dart';
import 'package:yousef1234321/features/parts_details/screen/parts_details_screen.dart';

import 'package:yousef1234321/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:yousef1234321/features/profile/language/screen/language_screen.dart';
import 'package:yousef1234321/features/profile/location/screen/location_page_screen.dart';

import 'package:yousef1234321/features/payment/screen/payment.dart';
import 'package:yousef1234321/features/profile/my_listing/screen/my_listing_page.dart';

import 'package:yousef1234321/features/profile/recent_gaeage/screen/recent_garage_page.dart';
import 'package:yousef1234321/features/splash/screen/splash_screen.dart';
import 'package:yousef1234321/features/support/screen/support_page.dart';

import '../features/brake_pads/screen/brake_pads_screen.dart';
import '../features/home/find_garage/screen/find_garage_page.dart';
import '../features/service/service_booking/screen/service_booking.dart';
import '../features/service/service_booking/widgets/service_message.dart';

class Approute {
  static String splashScreen = '/splashScreen';
  static String onboardingScreen = '/onboardingScreen';
  static String signInScreen = '/signInScreen';
  static String signUpScreen = '/signUpScreen';
  static String forgetPasswordScreen = '/forgetPasswordScreen';
  static String resetPasswordScreen = '/resetPasswordScreen';
  static String bottomNavBarScreen = '/bottomNavBarScreen';
  //home
  static String findGaragePage = '/home/findGaragePage';
  static String garageListPage = '/home/garageListPage';
  //service
  static String serviceBooking = "/service/serviceBooking";
  static String serviceMessage = "/service/ServiceMessage";
  //parts details
  static String partsDetailsScreen = '/partsDetailsScreen';
  static String brakePadsScreen = '/brakePadsScreen';
  static String payment = "/Payment";

  //helpSupport
  static String helpSupportScreen = '/helpSupportScreen';
  //contact_us
  static String contractUsScreen = '/contact_us_screen';
  // profile
  static String recentGaragePage = "/profile/recentGaragePage";

  //location_page
  static String locationPageScreen = "/profile/location";
  //EditProfileScreen
  static String editProfileScreen = "/profile/editProfileScreen";

  static String myListingPage = "/profile/myListingPage";
  //language
  static String languageScreen = "/profile/languageScreen";
  //chatlist
  static String chatScreen = "/chatScreen";
  static String getsignupOtpScreen = "/signupOtpScreen";
  //product details
  static String productDetailsScreen = "/product/productDetailsScreen";

  static String getSplashScreen() => splashScreen;
  static String getOnboardingScreen() => onboardingScreen;
  static String getSignInScreen() => signInScreen;
  static String getSignUpScreen() => signUpScreen;
  static String getForgetPasswordScreen() => forgetPasswordScreen;
  static String getResetPasswordScreen() => resetPasswordScreen;
  //home
  static String getfindGaragePage() => findGaragePage;
  static String getGarageListPage() => garageListPage;
  //service
  static String getServiceBooking() => serviceBooking;
  static String getServiceMessage() => serviceMessage;

  //parts ddeatais
  static String getPartsDetailsScreen() => partsDetailsScreen;
  static String getBrakePadsScreen() => brakePadsScreen;
  static String getPayment() => payment;
  // help support
  static String getHelpSupportScreen() => helpSupportScreen;
  //contract us
  static String getContractUsScreen() => contractUsScreen;

  //profile
  static String getrecentGaragePage() => recentGaragePage;

  //location_page
  static String getlocationPageScreen() => locationPageScreen;
  //edit profile
  static String getEditProfileScreen() => editProfileScreen;

  static String getmyListingPage() => myListingPage;
  //language
  static String getLanguageScreen() => languageScreen;
  //chatlist
  static String getChatScreen() => chatScreen;
  static String getSignupOtpScreen() => getsignupOtpScreen;
  //product details
  static String getProductDetailsScreen() => productDetailsScreen;

  static List<GetPage> routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onboardingScreen, page: () => OnboardingScreen()),
    GetPage(
      name: signInScreen,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: forgetPasswordScreen, page: () => ForgetPasswordScreen()),
    GetPage(name: resetPasswordScreen, page: () => const ResetPasswordScreen()),
    GetPage(name: bottomNavBarScreen, page: () => BottomNavbarScreen()),
    //home
    GetPage(name: findGaragePage, page: () => FindGaragePage()),
    GetPage(name: garageListPage, page: () => const GarageListScreen()),
    //service
    GetPage(name: serviceBooking, page: () => ServiceBooking()),
    GetPage(name: serviceMessage, page: () => ServiceMessage()),

    //PARTS DEATAILS
    GetPage(name: partsDetailsScreen, page: () => const PartsDetailsScreen()),

    GetPage(name: brakePadsScreen, page: () => BrakePadsScreen()),
    GetPage(name: payment, page: () => Payment()),

    // help support
    GetPage(name: helpSupportScreen, page: () => const HelpSupportScreen()),

    //contract us
    GetPage(name: contractUsScreen, page: () => const ContactUsScreen()),

    //profuile
    GetPage(name: recentGaragePage, page: () => RecentGaragePage()),

    // location_page
    GetPage(name: locationPageScreen, page: () => LocationPageScreen()),
    //edit profile
    GetPage(name: editProfileScreen, page: () => EditProfileScreen()),

    GetPage(name: myListingPage, page: () => MyListingPage()),
    //language
    GetPage(name: languageScreen, page: () => LanguageScreen()),

    //chatlist
    GetPage(name: chatScreen, page: () => ChatPage()),
    GetPage(name: getsignupOtpScreen, page: () => SignupOtpScreen()),
    //product details
    GetPage(name: productDetailsScreen, page: () => const PartsDetailsScreen()),
  ];
}
