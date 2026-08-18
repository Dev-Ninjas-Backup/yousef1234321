import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class BrakePadsService {
  final ApiClient _apiClient;

  BrakePadsService(this._apiClient);

  Future<Response> fetchProductDetails(String productId) async {
    return await _apiClient.get('${Endpoint.products}/$productId');
  }
}
