import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/route_manager.dart';
import 'package:yousef1234321/features/auth/forget_password/reset_password/reset_password_binding.dart';
import 'package:yousef1234321/features/auth/forget_password/reset_password/reset_password_screen.dart';
import 'package:yousef1234321/features/auth/forget_password/binding/forget_password_binding.dart';
import 'package:yousef1234321/features/auth/forget_password/screen/forget_password_screen.dart';
import 'package:yousef1234321/features/auth/sign_in/binding/sign_in_binding.dart';
import 'package:yousef1234321/features/notification/binding/notification_binding.dart';
import 'package:yousef1234321/features/notification/screen/notification_screen.dart';
import 'package:yousef1234321/features/onboarding/binding/onboarding_binding.dart';
import 'package:yousef1234321/features/onboarding/screen/onboarding_screen.dart';
import 'package:yousef1234321/features/auth/sign_in/screen/sign_in_screen.dart';
import 'package:yousef1234321/features/auth/sign_up/binding/sign_up_binding.dart';
import 'package:yousef1234321/features/auth/sign_up/screen/sign_up_screen.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/binding/signup_otp_binding.dart';
import 'package:yousef1234321/features/auth/sign_up/signup_otp/screen/otp_screen.dart';
import 'package:yousef1234321/features/bottom_navbar/binding/bottom_navbar_binding.dart';
import 'package:yousef1234321/features/chat/binding/chat_page_binding.dart';
import 'package:yousef1234321/features/chat/screen/chat_screen_list.dart';
import 'package:yousef1234321/features/splash/binding/splash_binding.dart';
import 'package:yousef1234321/features/bottom_navbar/screen/bottom_navbar_screen.dart';
import 'package:yousef1234321/features/brake_pads/binding/brake_pads_binding.dart';
import 'package:yousef1234321/features/brake_pads/screen/brake_pads_screen.dart';
import 'package:yousef1234321/features/contact_us/binding/contact_us_binding.dart';
import 'package:yousef1234321/features/contact_us/screen/contact_us_screen.dart';
import 'package:yousef1234321/features/help_support/binding/help_support_binding.dart';
import 'package:yousef1234321/features/help_support/screen/help_support_screen.dart';
import '../features/home/garage_list/binding/garage_list_binding.dart';
import 'package:yousef1234321/features/home/garage_list/screen/garage_list_screen.dart';

import '../features/parts_details/binding/parts_details_binding.dart';
import '../features/parts_details/screen/parts_details_screen.dart';

import 'package:yousef1234321/features/profile/edit_profile/binding/edit_profile_binding.dart';
import 'package:yousef1234321/features/profile/edit_profile/screen/edit_profile_screen.dart';
import 'package:yousef1234321/features/profile/language/binding/language_binding.dart';
import 'package:yousef1234321/features/profile/language/screen/language_screen.dart';
import 'package:yousef1234321/features/profile/location/binding/location_page_binding.dart';
import 'package:yousef1234321/features/profile/location/screen/location_page_screen.dart';

import 'package:yousef1234321/features/payment/binding/payment_binding.dart';
import 'package:yousef1234321/features/payment/screen/payment.dart';
import 'package:yousef1234321/features/profile/my_listing/binding/my_listing_binding.dart';
import 'package:yousef1234321/features/profile/my_listing/screen/my_listing_page.dart';

import 'package:yousef1234321/features/profile/recent_gaeage/binding/recent_garage_binding.dart';
import 'package:yousef1234321/features/profile/recent_gaeage/screen/recent_garage_page.dart';
import 'package:yousef1234321/features/splash/screen/splash_screen.dart';

import '../features/home/find_garage/binding/find_garage_binding.dart';
import '../features/home/find_garage/screen/find_garage_page.dart';
import '../features/service/service_booking/binding/service_booking_binding.dart';
import '../features/service/service_booking/screen/service_booking.dart';
import '../features/service/service_booking/widgets/service_message.dart';
import '../features/service/rate_service/screen/service_review_screen.dart';
import '../features/service/rate_service/binding/service_review_binding.dart';

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
  static String rateServiceScreen = "/service/rateServiceScreen";
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
  static String notificationScreen = '/notificationScreen';

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
  static String getRateServiceScreen() => rateServiceScreen;

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
  static String getNotificationScreen() => notificationScreen;

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: notificationScreen,
      page: () => const NotificationScreen(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: onboardingScreen,
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: signInScreen,
      page: () => const SignInScreen(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: forgetPasswordScreen,
      page: () => ForgetPasswordScreen(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: resetPasswordScreen,
      page: () => const ResetPasswordScreen(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: bottomNavBarScreen,
      page: () => BottomNavbarScreen(),
      binding: BottomNavbarBinding(),
    ),
    //home
    GetPage(
      name: findGaragePage,
      page: () => FindGaragePage(),
      binding: FindGarageBinding(),
    ),
    GetPage(
      name: garageListPage,
      page: () => const GarageListScreen(),
      binding: GarageListBinding(),
    ),
    //service
    GetPage(
      name: serviceBooking,
      page: () => ServiceBooking(),
      binding: ServiceBookingBinding(),
    ),
    GetPage(name: serviceMessage, page: () => ServiceMessage()),
    GetPage(
      name: rateServiceScreen,
      page: () => ServiceReviewScreen(),
      binding: ServiceReviewBinding(),
    ),

    //PARTS DEATAILS
    GetPage(
      name: partsDetailsScreen,
      page: () => const PartsDetailsScreen(),
      binding: PartsDetailsBinding(),
    ),

    GetPage(
      name: brakePadsScreen,
      page: () => BrakePadsScreen(),
      binding: BrakePadsBinding(),
    ),
    GetPage(name: payment, page: () => Payment(), binding: PaymentBinding()),

    // help support
    GetPage(
      name: helpSupportScreen,
      page: () => const HelpSupportScreen(),
      binding: HelpSupportBinding(),
    ),

    //contract us
    GetPage(
      name: contractUsScreen,
      page: () => const ContactUsScreen(),
      binding: ContactUsBinding(),
    ),

    //profuile
    GetPage(
      name: recentGaragePage,
      page: () => RecentGaragePage(),
      binding: RecentGarageBinding(),
    ),

    // location_page
    GetPage(
      name: locationPageScreen,
      page: () => LocationPageScreen(),
      binding: LocationPageBinding(),
    ),
    //edit profile
    GetPage(
      name: editProfileScreen,
      page: () => EditProfileScreen(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: myListingPage,
      page: () => MyListingPage(),
      binding: MyListingBinding(),
    ),
    //language
    GetPage(
      name: languageScreen,
      page: () => LanguageScreen(),
      binding: LanguageBinding(),
    ),

    //chatlist
    GetPage(
      name: chatScreen,
      page: () => ChatScreen(),
      binding: ChatPageBinding(),
    ),
    GetPage(
      name: getsignupOtpScreen,
      page: () => SignupOtpScreen(),
      binding: SignupOtpBinding(),
    ),
    //product details
    GetPage(
      name: productDetailsScreen,
      page: () => const PartsDetailsScreen(),
      binding: PartsDetailsBinding(),
    ),
  ];
}
