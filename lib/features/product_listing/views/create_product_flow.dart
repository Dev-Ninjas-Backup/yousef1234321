import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../models/product_models.dart';
import '../services/product_api_service.dart';
import 'payment_webview_screen.dart';

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
    if (error is Map) {
      final String code = (error['code'] ??
              (error['message'] is Map ? error['message']['code'] : null) ??
              '')
          .toString();
      final String rawMessage = (error['message'] is String
              ? error['message']
              : (error['message'] is Map
                  ? (error['message']['text'] ?? error['message']['message'])
                  : error.toString()))
          .toString();
      final String lowerMessage = rawMessage.toLowerCase();

      final bool isPayPerRequired = code == 'PAY_PER_PAYMENT_REQUIRED' ||
          lowerMessage.contains('pay_per_payment_required') ||
          lowerMessage.contains('pay per payment required') ||
          lowerMessage.contains('pay-per payment required');

      final bool isSubscriptionRequired =
          code == 'PRODUCT_MONTHLY_SUBSCRIPTION_REQUIRED' ||
              lowerMessage.contains('product_monthly_subscription_required') ||
              lowerMessage.contains('monthly subscription required');

      final bool isPromotionRequired = code == 'PROMOTION_PAYMENT_REQUIRED' ||
          lowerMessage.contains('promotion_payment_required') ||
          lowerMessage.contains('payment required for product promotion') ||
          lowerMessage.contains('promotion payment required');

      if (isPayPerRequired) {
        debugPrint("PAY_PER_PAYMENT_REQUIRED - Redirecting to in-app payment...");
        EasyLoading.showInfo("Opening payment...");
        try {
          final String checkoutUrl =
              await apiService.createPayPerPaymentSession();
          if (checkoutUrl.isNotEmpty) {
            await openStripeWebView(checkoutUrl, title: 'Pay-Per-Listing Payment');
          } else {
            EasyLoading.showError("Failed to generate payment URL.");
          }
        } catch (e) {
          debugPrint("Failed to initiate payment session: $e");
          EasyLoading.showError("Failed to initiate payment session.");
        }
      } else if (isSubscriptionRequired) {
        debugPrint("PRODUCT_MONTHLY_SUBSCRIPTION_REQUIRED - Redirecting to in-app payment...");
        EasyLoading.showInfo("Opening subscription...");
        try {
          final String checkoutUrl = await apiService
              .createMonthlySubscriptionSession(planType: 'PRO');
          if (checkoutUrl.isNotEmpty) {
            await openStripeWebView(checkoutUrl, title: 'Subscription Payment');
          } else {
            EasyLoading.showError("Failed to generate subscription URL.");
          }
        } catch (e) {
          debugPrint("Failed to initiate subscription session: $e");
          EasyLoading.showError("Failed to initiate subscription session.");
        }
      } else if (isPromotionRequired) {
        debugPrint("PROMOTION_PAYMENT_REQUIRED - Redirecting to in-app payment...");
        EasyLoading.showInfo("Opening promotion payment...");
        try {
          final String checkoutUrl =
              await apiService.createPromotionPaymentSession(
            duration: request.promotedDuration ?? '7',
            useCredits: request.usePromotionCredits,
          );
          if (checkoutUrl.isNotEmpty) {
            await openStripeWebView(checkoutUrl, title: 'Promotion Payment');
          } else {
            EasyLoading.showError("Failed to generate promotion payment URL.");
          }
        } catch (e) {
          debugPrint("Failed to initiate promotion payment: $e");
          EasyLoading.showError("Failed to initiate promotion payment.");
        }
      } else {
        debugPrint("API Error Message: $rawMessage");
        EasyLoading.showError(rawMessage.isNotEmpty ? rawMessage : "Failed to create product.");
      }
    } else {
      EasyLoading.showError("Unexpected error occurred.");
    }
    return false;
  }
}

Future<bool> openStripeWebView(String url, {String title = 'Complete Payment'}) async {
  final result = await Get.to<bool>(
    () => PaymentWebViewScreen(initialUrl: url, title: title),
  );
  return result ?? false;
}
