/// API Endpoints
///
/// This class contains all API endpoint paths.
/// The baseUrl is set in ApiClient, so endpoints should only contain the path.
///
/// Example usage:
/// ```dart
/// ApiClient.to.post(Endpoint.login, body);
/// ```
class Endpoint {
  // Keep baseUrl here, ApiClient sets httpClient.baseUrl = Endpoint.baseUrl
  static const String baseUrl = 'http://10.10.10.64:5050';

  // Auth endpoints (path-only)
  static const String register = '/auth/register';
  static const String otpVerification = '/auth/signup-verify-otp';
  static const String login = '/auth/login';
  static const String googleLogin = '/auth/google-login';
  static const String profile = '/user/me/profile';
  static const String editProfile = '/user/profile';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/reset-verify-otp';
  static const String contactUs = '/contact';

  // Products & parts
  static const String products = '/products';
  static const String partsCategory = '/parts-category';
  static const String myListing = '/products/my-products';

  // Services & garages
  static const String getService = '/services';
  static const String findGarage = '/garages';
  static const String garageDetails = '/garages/single-garage';
  static const String garageNearby = '/garages/nearby';

  // Categories & notifications
  static const String categories = '/categories';
  static const String notificationIO = '/notification';
  static const String userNotifications =
      '/notification-setting/all-notifications';
}
