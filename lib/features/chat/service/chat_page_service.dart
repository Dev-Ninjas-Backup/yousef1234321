import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';

class ChatPageService {
  final ApiClient _apiClient;

  ChatPageService(this._apiClient);

  Future<Response> getPrivateChats() async {
    return await _apiClient.get('/private-chat');
  }

  Future<Response> markAsRead1(String recipientId) async {
    return await _apiClient.patch('/private-chat/$recipientId/read', {});
  }

  Future<Response> markAsRead2(String recipientId) async {
    return await _apiClient.patch('/private-chat/read/$recipientId', {});
  }
}
