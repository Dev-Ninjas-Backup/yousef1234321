

// ignore: library_prefixes

import 'package:flutter/foundation.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class NotificationSocketService {
  static final NotificationSocketService _instance =
      NotificationSocketService._internal();

  factory NotificationSocketService() => _instance;
  NotificationSocketService._internal();

  IO.Socket? socket;

  void connect({
    required String token,
    required Function(dynamic data) onNotification,
  }) {
    socket = IO.io(
      Endpoint.notificationIO,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .setExtraHeaders({'Authorization': "Bearer $token"})
          .build(),
    );

    socket!.onConnect((_) {
      debugPrint('✅ Notification socket connected');
    });

    socket!.onDisconnect((_) {
      debugPrint('❌ Notification socket disconnected');
    });

    socket!.onConnectError((err) {
      debugPrint('⚠️ Socket connect error: $err');
    });

    /// Backend emits ALL notifications on one event
    //socket!.on('notification', onNotification);
    socket!.on('customer-inquiry-alert', (data) {
      debugPrint('CustomerInquiryAlert_CREATE: $data');
      onNotification(data);
    });

    // socket!.on('productApproveUpdateMeta_UPDATE', (data) {
    //   debugPrint('productApproveUpdateMeta_UPDATE received: $data');
    //   onNotification(data);
    // });

    socket!.connect();
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
