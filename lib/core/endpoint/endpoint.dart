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
  static const String baseUrl =
      'https://impracticably-sclerometric-niki.ngrok-free.dev';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String otpVerification = '/auth/signup-verify-otp';
  static const String login = '/auth/login';
  static const String profile = '/user/me/profile';
  static const String editProfile = '/user/profile';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/reset-verify-otp';
  static const String contactUs = '/contact';
  static const String getService = '/services';
  static const String findGarage = '/garages';
  static const String garageDetails = '/garages/single-garage';
}
