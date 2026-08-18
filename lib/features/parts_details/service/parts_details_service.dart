import 'package:http/http.dart' as http;
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class PartsDetailsService {
  final ApiClient _apiClient;

  PartsDetailsService(this._apiClient);

  Future<http.Response> createMonthlyPayment() async {
    return await http.post(
      Uri.parse("${Endpoint.baseUrl}/products/create-monthly-payment"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiClient.token}',
      },
    );
  }

  Future<http.Response> createPayPerListingPayment() async {
    return await http.post(
      Uri.parse("${Endpoint.baseUrl}/products/create-payper-payment"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiClient.token}',
      },
    );
  }

  Future<http.Response> createPromotionPayment() async {
    return await http.post(
      Uri.parse("${Endpoint.baseUrl}/products/create-promotion-payment"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiClient.token}',
      },
    );
  }

  Future<http.Response> checkUserProductLimit() async {
    return await http.get(
      Uri.parse("${Endpoint.baseUrl}/products/user/limit"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiClient.token}',
      },
    );
  }

  Future<http.Response> fetchCategories() async {
    return await http.get(
      Uri.parse("${Endpoint.baseUrl}/parts-category"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_apiClient.token}',
      },
    );
  }

  Future<http.StreamedResponse> createProduct(
    http.MultipartRequest request,
  ) async {
    request.headers['Authorization'] = 'Bearer ${_apiClient.token}';
    return await request.send();
  }
}
