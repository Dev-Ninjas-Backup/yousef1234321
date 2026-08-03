import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../models/product_models.dart';
import '../services/product_api_service.dart';

Future<bool> handleCreateProduct(ProductApiService apiService, CreateProductRequest request) async {
  try {
    EasyLoading.show(status: 'Creating product...');
    final result = await apiService.createProduct(request);
    debugPrint("Product created successfully: $result");
    EasyLoading.showSuccess("Product created successfully");
    return true;
  } catch (error) {
    debugPrint("Error creating product: $error");
    EasyLoading.dismiss();
    if (error is Map && error.containsKey('message')) {
      final messageObj = error['message'];
      final String? errorCode = messageObj is Map ? messageObj['code'] : null;

      if (errorCode == 'PAY_PER_PAYMENT_REQUIRED') {
        debugPrint("PAY_PER_PAYMENT_REQUIRED - Redirecting to stripe...");
        EasyLoading.showInfo("Redirecting to payment...");
        final String checkoutUrl = await apiService.createPayPerPaymentSession();
        openStripeWebView(checkoutUrl);
      } else if (errorCode == 'PRODUCT_MONTHLY_SUBSCRIPTION_REQUIRED') {
        debugPrint("PRODUCT_MONTHLY_SUBSCRIPTION_REQUIRED - Redirecting to stripe...");
        EasyLoading.showInfo("Redirecting to subscription...");
        final String checkoutUrl = await apiService.createMonthlySubscriptionSession(planType: 'PRO');
        openStripeWebView(checkoutUrl);
      } else if (errorCode == 'PROMOTION_PAYMENT_REQUIRED') {
        debugPrint("PROMOTION_PAYMENT_REQUIRED - Redirecting to stripe...");
        EasyLoading.showInfo("Redirecting to promotion payment...");
        final String checkoutUrl = await apiService.createPromotionPaymentSession(
          duration: request.promotedDuration ?? '7',
        );
        openStripeWebView(checkoutUrl);
      } else {
        debugPrint("API Error Message: ${error['message']}");
        EasyLoading.showError(error['message'].toString());
      }
    } else {
      EasyLoading.showError("Unexpected error occurred.");
    }
    return false;
  }
}

Future<void> openStripeWebView(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch URL: $url");
    EasyLoading.showError('Could not launch payment URL');
  }
}
