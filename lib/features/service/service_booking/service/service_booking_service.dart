import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';

class ServiceBookingService {
  final ApiClient _apiClient;

  ServiceBookingService(this._apiClient);

  Future<Map<String, dynamic>> fetchConversationHistory() async {
    final response = await _apiClient.get('/private-chat');
    return {'statusCode': response.statusCode, 'body': response.body};
  }

  Future<Map<String, dynamic>> fetchSingleConversation(
    String conversationId,
  ) async {
    final response = await _apiClient.get('/private-chat/$conversationId');
    return {'statusCode': response.statusCode, 'body': response.body};
  }

  Future<http.Response> sendTextMessage(
    String content,
    String recipientId,
  ) async {
    final uri = Uri.parse(
      '${Endpoint.baseUrl}/private-chat/send-message/$recipientId',
    );
    final token = _apiClient.token ?? '';
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['content'] = content;
    request.fields['recipientId'] = recipientId;

    final streamed = await request.send();
    return await http.Response.fromStream(streamed);
  }

  Future<http.Response> sendMessageWithFiles(
    String content,
    String recipientId,
    List<String> filePaths,
  ) async {
    final uri = Uri.parse(
      '${Endpoint.baseUrl}/private-chat/send-message/$recipientId',
    );
    final token = _apiClient.token ?? '';

    final safeContent = content.trim().isEmpty ? 'Attachment' : content.trim();

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['content'] = safeContent
      ..fields['recipientId'] = recipientId;

    for (final filePath in filePaths) {
      final file = File(filePath);
      if (await file.exists()) {
        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: file.path.split('/').last,
        );
        request.files.add(multipartFile);
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<Map<String, dynamic>> fetchGarageDetails(String garageId) async {
    final endpoint = '${Endpoint.garageDetails}/$garageId';
    final response = await _apiClient.get(endpoint);
    return {'statusCode': response.statusCode, 'body': response.body};
  }

  Future<Map<String, dynamic>> fetchServices() async {
    final response = await _apiClient.get(Endpoint.getService);
    return {'statusCode': response.statusCode, 'body': response.body};
  }
}
