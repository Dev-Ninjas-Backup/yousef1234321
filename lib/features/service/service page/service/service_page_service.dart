import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/features/service/service%20page/model/garage_model.dart';

class ServicePageService {
  final ApiClient _apiClient;

  ServicePageService(this._apiClient);

  Future<Map<String, dynamic>> fetchApprovedGarages({
    required int page,
    required int limit,
  }) async {
    final url = '${Endpoint.allApprovedGarage}&page=$page&limit=$limit';
    final res = await _apiClient.get(url);

    if (res.statusCode == 200 && res.body != null) {
      final body = res.body;
      List<dynamic> list = [];
      Map? pagination;

      if (body is Map) {
        if (body['data'] is Map) {
          final dataMap = body['data'];
          if (dataMap['data'] is List) {
            list = List<dynamic>.from(dataMap['data']);
          }
          if (dataMap['pagination'] is Map) {
            pagination = Map<String, dynamic>.from(dataMap['pagination']);
          }
        } else if (body['data'] is List) {
          list = List<dynamic>.from(body['data']);
        }

        if (body['pagination'] is Map) {
          pagination = Map<String, dynamic>.from(body['pagination']);
        }
      }

      final models = list
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return {'garages': models, 'pagination': pagination};
    }
    throw Exception('Failed to load approved garages');
  }

  Future<List<GarageModel>> findGaragesNearby({
    required double lat,
    required double lng,
    required double radius,
  }) async {
    final url = '${Endpoint.garageNearby}?lat=$lat&lng=$lng&radius=$radius';
    final res = await _apiClient.get(url);

    if (res.statusCode == 200 && res.body != null) {
      final body = res.body;
      List<dynamic> list = [];

      if (body is Map) {
        if (body['garages'] is List) {
          list = List<dynamic>.from(body['garages']);
        } else if (body['data'] is List) {
          list = List<dynamic>.from(body['data']);
        } else if (body['data'] is Map && body['data']['data'] is List) {
          list = List<dynamic>.from(body['data']['data']);
        } else if (body.values.any((v) => v is List)) {
          final lists = body.values.whereType<List>().toList();
          if (lists.isNotEmpty) list = List<dynamic>.from(lists.first);
        }
      } else if (body is List) {
        list = List<dynamic>.from(body);
      }

      return list
          .where((e) => e != null && e is Map<String, dynamic>)
          .map((e) => GarageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception('Failed to fetch nearby garages');
  }
}
