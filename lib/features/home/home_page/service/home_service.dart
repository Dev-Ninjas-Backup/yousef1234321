import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/features/home/home_page/model/garage_model.dart';

class HomeService {
  final ApiClient _apiClient;

  HomeService(this._apiClient);

  Future<List<GarageModel>> fetchTopRatedGarages() async {
    // Fetch more garages (limit 10) to have better selection for top 2
    var response = await _apiClient.get(
      '${Endpoint.findGarage}?page=1&limit=10&status=APPROVED&sortBy=averageRating&order=desc',
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;
      if (body != null &&
          body['success'] == true &&
          body['data'] != null &&
          body['data']['data'] != null) {
        final List<dynamic> garagesJson = body['data']['data'];

        // If no APPROVED garages found, try fetching all garages
        if (garagesJson.isEmpty) {
          response = await _apiClient.get(
            '${Endpoint.findGarage}?page=1&limit=10&sortBy=averageRating&order=desc',
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final allBody = response.body;
            if (allBody != null &&
                allBody['success'] == true &&
                allBody['data'] != null &&
                allBody['data']['data'] != null) {
              final allGaragesJson = allBody['data']['data'] as List<dynamic>;
              return _parseAndSortGarages(allGaragesJson);
            }
          }
          return [];
        } else {
          return _parseAndSortGarages(garagesJson);
        }
      }
    }
    throw Exception("Failed to fetch garages");
  }

  List<GarageModel> _parseAndSortGarages(List<dynamic> jsonList) {
    final garagesList = jsonList
        .map((json) => GarageModel.fromJson(json))
        .toList();
    garagesList.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return garagesList.take(2).toList();
  }

  Future<List<String>> fetchServices() async {
    final response = await _apiClient.get(Endpoint.getService);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.body;

      if (body != null) {
        List<dynamic>? categories;
        if (body['data'] is List) {
          categories = body['data'];
        } else if (body['serviceCategories'] is List) {
          categories = body['serviceCategories'];
        }

        if (categories != null) {
          return categories
              .map((e) {
                if (e is Map) return e['name']?.toString() ?? '';
                return e.toString();
              })
              .where((s) => s.isNotEmpty)
              .toList();
        }
      }
      return [];
    }
    throw Exception("Failed to fetch services");
  }
}
