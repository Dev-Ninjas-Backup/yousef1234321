// ignore_for_file: avoid_print

import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:yousef1234321/features/notification/notification_model.dart';
import 'package:yousef1234321/features/notification/service/notification_rest_service.dart';
import 'package:yousef1234321/features/notification/service/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationServiceRest notificationServiceREST =
      NotificationServiceRest();

  final RxBool isLoading = false.obs;
  final RxList<AppNotification> notifications = <AppNotification>[].obs;

  final NotificationSocketService _socketService = NotificationSocketService();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;
      final notification = await notificationServiceREST.getNotifications();

      notifications.assignAll(notification);
      print(
        "===================Notification Length: ${notification.length}===================",
      );
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void connectSocket(String token) {
    _socketService.connect(token: token, onNotification: _handleNotification);
  }

  void _handleNotification(dynamic data) {
    try {
      final notification = AppNotification.fromJson(
        Map<String, dynamic>.from(data),
      );

      final exists = notifications.any((n) => n.id == notification.id);
      if (!exists) {
        notifications.insert(0, notification);
      }
    } catch (e) {
      print('❌ Notification parse error: $e');
    }
  }

  void disconnectSocket() {
    _socketService.disconnect();
  }
}
