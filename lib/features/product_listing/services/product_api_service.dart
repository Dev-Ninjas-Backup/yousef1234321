import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:yousef1234321/features/parts_details/model.dart/part_categories_model.dart';
import '../models/product_models.dart';

class ProductApiService {
  final String baseUrl;
  final String token;

  ProductApiService({required this.baseUrl, required this.token});

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  /// Check User Product Listing Limit Quota
  Future<ProductLimitQuota> checkUserQuota({String? garageId}) async {
    final uri = Uri.parse('$baseUrl/products/user/limit').replace(
      queryParameters: garageId != null ? {'garageId': garageId} : null,
    );

    final response = await http.get(uri, headers: _headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ProductLimitQuota.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to check user quota: ${response.body}');
    }
  }

  /// Fetch Categories
  Future<List<PartCategory>> fetchCategories() async {
    final uri = Uri.parse('$baseUrl/parts-category');
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success'] == true) {
        List<dynamic> dataList = jsonData['data']['data'] ?? jsonData['data'];
        return dataList.map((e) => PartCategory.fromJson(e)).toList();
      }
    }
    throw Exception('Failed to load categories');
  }

  /// Create Product with Multipart Files
  Future<Map<String, dynamic>> createProduct(CreateProductRequest req) async {
    final uri = Uri.parse('$baseUrl/products');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';

    // Text Fields
    request.fields['partName'] = req.partName;
    request.fields['categoryId'] = req.categoryId;
    request.fields['condition'] = req.condition;
    request.fields['price'] = req.price.toString();
    request.fields['quantity'] = req.quantity.toString();
    request.fields['sellerType'] = req.sellerType.name;
    request.fields['sellerEmail'] = req.sellerEmail;
    String planString = req.plan.name;
    if (req.plan == ListingPlan.MONTHLY_BASIC ||
        req.plan == ListingPlan.MONTHLY_PRO) {
      planString = 'MONTHLY';
    }
    request.fields['plan'] = planString;

    if (req.brand != null) request.fields['brand'] = req.brand!;
    if (req.description != null)
      request.fields['description'] = req.description!;
    if (req.sellerName != null) request.fields['sellerName'] = req.sellerName!;
    if (req.sellerPhoneNumber != null)
      request.fields['sellerPhoneNumber'] = req.sellerPhoneNumber!;
    if (req.garageId != null) request.fields['garageId'] = req.garageId!;
    request.fields['isPromoted'] = req.isPromoted.toString();
    if (req.promotedDuration != null)
      request.fields['promotedDuration'] = req.promotedDuration!;
    request.fields['usePromotionCredits'] = req.usePromotionCredits
        ? 'true'
        : 'false';
    request.fields['useCredits'] = req.usePromotionCredits ? 'true' : 'false';

    // Attach Product Photos
    for (String path in req.photoPaths) {
      final ext = path.split('.').last.toLowerCase();
      final type = ext == 'png' ? 'png' : 'jpeg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'photos',
          path,
          contentType: MediaType('image', type),
        ),
      );
    }

    // Attach Verification Image (Required for VERIFIED_SUPPLIER)
    if (req.verificationImagePath != null) {
      final ext = req.verificationImagePath!.split('.').last.toLowerCase();
      final type = ext == 'png' ? 'png' : 'jpeg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'verificationImage',
          req.verificationImagePath!,
          contentType: MediaType('image', type),
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    } else {
      // Return custom error body containing code like PAY_PER_PAYMENT_REQUIRED
      throw responseData;
    }
  }

  /// Generate Pay-Per Checkout Session
  Future<String> createPayPerPaymentSession() async {
    final uri = Uri.parse('$baseUrl/products/create-payper-payment');
    final response = await http.post(uri, headers: _headers);
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final url =
          data['url'] ??
          (data['data'] != null ? data['data']['checkoutUrl'] : null);
      return url ?? '';
    } else {
      throw data;
    }
  }

  /// Generate Monthly Subscription Session
  Future<String> createMonthlySubscriptionSession({
    String planType = 'PRO',
  }) async {
    final uri = Uri.parse('$baseUrl/products/create-monthly-payment');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'planType': planType}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final url =
          data['url'] ??
          (data['data'] != null ? data['data']['checkoutUrl'] : null);
      return url ?? '';
    } else {
      throw data;
    }
  }

  /// Generate Promotion Payment Session
  Future<String> createPromotionPaymentSession({
    String duration = '7',
    bool useCredits = true,
  }) async {
    final uri = Uri.parse('$baseUrl/products/create-promotion-payment');
    final response = await http.post(
      uri,
      headers: _headers,
      body: jsonEncode({'duration': duration, 'useCredits': useCredits}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final url =
          data['url'] ??
          (data['data'] != null ? data['data']['checkoutUrl'] : null);
      return url ?? '';
    } else {
      throw data;
    }
  }

  /// Downgrade Product Plan
  Future<Map<String, dynamic>> downgradeProductPlan({
    String planType = 'BASIC',
  }) async {
    final uri = Uri.parse('$baseUrl/subscription/downgrade-product-plan');
    final response = await http.patch(
      uri,
      headers: _headers,
      body: jsonEncode({'planType': planType}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data is Map<String, dynamic>
          ? data
          : {'message': 'Plan downgraded successfully'};
    } else {
      throw data;
    }
  }

  /// Get Payment Configure
  Future<Map<String, dynamic>> getPaymentConfigure() async {
    final uri = Uri.parse('$baseUrl/admin-setting/payment-config');
    final response = await http.get(uri, headers: _headers);
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data['data'] ?? data;
    } else {
      throw data;
    }
  }
}
