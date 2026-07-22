import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ServiceReviewService {
  final ApiClient _apiClient;

  ServiceReviewService(this._apiClient);

  Future<Map<String, dynamic>> submitReview(
    String garageId,
    Map<String, dynamic> body,
  ) async {
    final res = await _apiClient.post('${Endpoint.postReview}/$garageId', body);
    return {
      'statusCode': res.statusCode,
      'body': res.body,
      'bodyString': res.bodyString,
    };
  }
}
