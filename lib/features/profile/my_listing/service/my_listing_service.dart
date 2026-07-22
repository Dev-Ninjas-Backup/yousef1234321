import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class MyListingService {
  final ApiClient _apiClient;

  MyListingService(this._apiClient);

  Future<Response> getMyListings() async {
    return await _apiClient.get(Endpoint.myListing);
  }
}
