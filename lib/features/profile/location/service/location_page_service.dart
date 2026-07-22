import 'package:get/get_connect/http/src/response/response.dart';
import 'package:http/http.dart' as http;
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class LocationPageService {
  final ApiClient _apiClient;

  LocationPageService(this._apiClient);

  Future<Response> getProfile() async {
    return await _apiClient.get(Endpoint.profile);
  }

  Future<Response> updateLocation(Map<String, dynamic> body) async {
    return await _apiClient.patch(Endpoint.editProfile, body);
  }

  Future<http.Response> searchLocationByText(
    String query,
    String apiKey,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(query)}&key=$apiKey',
    );
    return await http.get(url);
  }

  Future<http.Response> reverseGeocode(
    double lat,
    double lng,
    String apiKey,
  ) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey',
    );
    return await http.get(url);
  }
}
