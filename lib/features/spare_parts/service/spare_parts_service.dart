import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class SparePartsService {
  final ApiClient _apiClient;

  SparePartsService(this._apiClient);

  Future<Response> fetchProducts(String url) async {
    return await _apiClient.get(url);
  }

  Future<Response> fetchCategories() async {
    return await _apiClient.get(Endpoint.partsCategory);
  }
}
