import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/notification/notification_model.dart';

class NotificationServiceRest {
  final String apiUrl =
      "${Endpoint.baseUrl}/notification-setting/all-notifications";
  final String token = ApiClient.to.token ?? '';

  // Method to fetch notifications from the server
  Future<List<AppNotification>> getNotifications() async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      // Check if the server returned a successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
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
