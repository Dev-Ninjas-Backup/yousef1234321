import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';

class GarageListService {
  final ApiClient _apiClient;

  GarageListService(this._apiClient);

  Future<Map<String, dynamic>> fetchGarages({
    required int page,
    required int limit,
    String? searchTerm,
    String? status,
    String? city,
    String? emirate,
    String? serviceName,
  }) async {
    String url = '${Endpoint.findGarage}?page=$page&limit=$limit';

    if (searchTerm != null && searchTerm.isNotEmpty) {
      url += '&searchTerm=${Uri.encodeQueryComponent(searchTerm)}';
    }
    if (status != null && status.isNotEmpty && status != 'all') {
      url += '&status=$status';
    }
    if (city != null && city.isNotEmpty) {
      url += '&city=${Uri.encodeQueryComponent(city)}';
    }
    if (emirate != null && emirate.isNotEmpty) {
      url += '&emirate=${Uri.encodeQueryComponent(emirate)}';
    }
    if (serviceName != null && serviceName.isNotEmpty) {
      final serviceVal = Uri.encodeQueryComponent(serviceName);
      url += '&serviceName=$serviceVal&service=$serviceVal';
    }

    final response = await _apiClient.get(url);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body['success'] == true && body['data'] != null) {
        final data = body['data'];
        List<dynamic> list = [];
        bool hasMore = true;

        if (data is Map && data['data'] is List) {
          list = data['data'];
          if (data['pagination'] != null) {
            final totalPages = data['pagination']['totalPages'] ?? 1;
            if (page >= totalPages) hasMore = false;
          }
        } else if (data is List) {
          list = data;
        }

        List<GarageModel> parsedGarages = list
            .where((e) => e != null && e is Map<String, dynamic>)
            .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();

        return {'garages': parsedGarages, 'hasMore': hasMore};
      }
    }
    throw Exception('Failed to fetch garages');
  }

  Future<List<String>> fetchServices() async {
    final response = await _apiClient.get(Endpoint.getService);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      List<dynamic>? categories;
      if (body != null) {
        if (body['data'] is List) {
          categories = body['data'];
        } else if (body['serviceCategories'] is List) {
          categories = body['serviceCategories'];
        }
      }

      if (categories != null) {
        return categories
            .map((e) => e is Map ? (e['name']?.toString() ?? '') : e.toString())
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }
    return [];
  }
}
