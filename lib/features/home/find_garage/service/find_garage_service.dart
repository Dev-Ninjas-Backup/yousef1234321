import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/features/service/service page/model/garage_model.dart';

class FindGarageService {
  final ApiClient _apiClient;

  FindGarageService(this._apiClient);

  Future<List<String>> fetchServiceCategories() async {
    final res = await _apiClient.get(Endpoint.getService);
    if (res.statusCode == 200 && res.body != null) {
      final body = res.body;
      List<dynamic>? categories;
      if (body['data'] is List) {
        categories = body['data'];
      } else if (body['serviceCategories'] is List) {
        categories = body['serviceCategories'];
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

  Future<List<GarageModel>> fetchGarages({
    String? emirate,
    String? serviceName,
    double? currentLat,
    double? currentLng,
  }) async {
    final Map<String, Map<String, dynamic>> garageMap = {};

    // 1. Fetch nearby garages API if coordinates exist
    if (currentLat != null && currentLng != null) {
      final url = '${Endpoint.garageNearby}?lat=$currentLat&lng=$currentLng';
      final res = await _apiClient.get(url);
      if (res.statusCode == 200 && res.body != null) {
        final body = res.body;
        List<dynamic> nearbyList = [];
        if (body is Map) {
          if (body['garages'] is List) {
            nearbyList = List<dynamic>.from(body['garages']);
          } else if (body['data'] is List) {
            nearbyList = List<dynamic>.from(body['data']);
          } else if (body['data'] is Map && body['data']['data'] is List) {
            nearbyList = List<dynamic>.from(body['data']['data']);
          }
        } else if (body is List) {
          nearbyList = List<dynamic>.from(body);
        }
        for (var item in nearbyList) {
          if (item is Map && item['id'] != null) {
            garageMap[item['id'].toString()] = Map<String, dynamic>.from(item);
          }
        }
      }
    }

    // 2. Fetch all approved garages endpoint
    String url = '${Endpoint.allApprovedGarage}&limit=100';
    if (emirate != null && emirate.isNotEmpty) {
      url += '&emirate=${Uri.encodeComponent(emirate)}';
    }
    if (serviceName != null && serviceName.isNotEmpty && serviceName != 'All') {
      url += '&search=${Uri.encodeComponent(serviceName)}';
    }
    final res = await _apiClient.get(url);
    if (res.statusCode == 200 && res.body != null) {
      final body = res.body;
      List<dynamic> approvedList = [];
      if (body is Map) {
        if (body['data'] is Map && body['data']['data'] is List) {
          approvedList = List<dynamic>.from(body['data']['data']);
        } else if (body['data'] is List) {
          approvedList = List<dynamic>.from(body['data']);
        } else if (body['garages'] is List) {
          approvedList = List<dynamic>.from(body['garages']);
        }
      } else if (body is List) {
        approvedList = List<dynamic>.from(body);
      }
      for (var item in approvedList) {
        if (item is Map && item['id'] != null) {
          garageMap[item['id'].toString()] = Map<String, dynamic>.from(item);
        }
      }
    }

    return garageMap.values.map((e) => GarageModel.fromJson(e)).toList();
  }
}
