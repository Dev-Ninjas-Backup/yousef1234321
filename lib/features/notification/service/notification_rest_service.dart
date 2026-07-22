import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/notification/notification_model.dart';

class NotificationServiceRest {
  final ApiClient _apiClient;

  NotificationServiceRest(this._apiClient);

  Future<List<AppNotification>> getNotifications() async {
    try {
      final response = await _apiClient.get(
        '/notification-setting/all-notifications',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final List notifications = body['data']['notifications'];
        return notifications.map((e) => AppNotification.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
