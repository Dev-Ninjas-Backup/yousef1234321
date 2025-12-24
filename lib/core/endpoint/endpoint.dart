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
  static const String baseUrl = 'https://yousef-server.saikat.com.bd';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String otpVerification = '/auth/signup-verify-otp';
  static const String login = '/auth/login';
  static const String forgetPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyOtp = '/auth/verify-otp';
}
