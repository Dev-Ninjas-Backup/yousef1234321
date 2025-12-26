// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/service_booking/model/garage_detail_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ServiceBookingController extends GetxController {
  final Rx<GarageDetailModel?> garageDetail = Rx<GarageDetailModel?>(null);
  final isLoading = false.obs;
  final hasError = false.obs;
  String? garageId;
  var images = [
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding2,
    Imagepath.onboarding1,
    Imagepath.onboarding1,
  ].obs;

  var services = [
    {"title": "AC Service", "icon": Iconpath.acIcon},
    {"title": "Battery Replacement", "icon": Iconpath.batterryIcon},
    {"title": "Tires", "icon": Iconpath.tire},
    {"title": "Engine Diagnostics", "icon": Iconpath.engineIcon},
    {"title": "Electrical", "icon": Iconpath.electricIcon},
    {"title": "Spares", "icon": Iconpath.spareIcon},
  ].obs;
  var isOpen = true.obs;

  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    loadInitialMessages();

    // Get garage ID from arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['garageId'] != null) {
      garageId = args['garageId'];
      fetchGarageDetails();
    }

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    chatScrollController.dispose();
    socket?.disconnect();
    super.onClose();
  }

  // Service messaging - Real-time Chat with WebSocket & REST API
  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;
  var isConnected = false.obs;
  var recipientId = RxnString();
  var conversationId = RxnString();
  TextEditingController textController = TextEditingController();
  ScrollController chatScrollController = ScrollController();
  IO.Socket? socket;

  void loadInitialMessages() {
    if (recipientId.value != null) {
      _fetchConversationHistory();
    }
  }

  void initializeChat(String? recId) {
    print(
      '🔵 [initializeChat] Starting chat initialization with recipientId: $recId',
    );
    recipientId.value = recId;
    print('🔵 [initializeChat] recipientId set to: ${recipientId.value}');
    loadInitialMessages();
    print('🔵 [initializeChat] loadInitialMessages called');
    _connectWebSocket();
    print('🔵 [initializeChat] _connectWebSocket called');
  }

  void _connectWebSocket() {
    try {
      print('🟡 [_connectWebSocket] Starting WebSocket connection');
      final token = ApiClient.to.token ?? '';
      print(
        '🟡 [_connectWebSocket] Token retrieved: ${token.isNotEmpty ? '✓ Found' : '✗ Empty'}',
      );

      socket = IO.io(
        '${Endpoint.baseUrl}/pv/message',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({'token': 'Bearer $token'})
            .build(),
      );
      print(
        '🟡 [_connectWebSocket] Socket instance created, connecting to ${Endpoint.baseUrl}/pv/message',
      );

      socket!.onConnect((_) {
        print('✅ [WebSocket] Connected to Private Chat WebSocket');
        isConnected.value = true;
        print('✅ [WebSocket] isConnected = true');
        _loadConversations();
      });

      socket!.on('private:success', (userId) {
        print('✅ [WebSocket] Authentication successful, userId: $userId');
      });

      socket!.on('private:new_message', (messageData) {
        print(
          '💬 [WebSocket] New message received: ${messageData['content'] ?? 'no content'}',
        );
        if (messageData != null) {
          try {
            final keys = (messageData as Map).keys.join(', ');
            print('💬 [WebSocket] Message keys: $keys');
            print('💬 [WebSocket] files field: ${messageData['files']}');
            print('💬 [WebSocket] file field: ${messageData['file']}');
          } catch (_) {}
          // Determine if this message is from the user or the other person
          // If sender ID is different from recipientId, it's from the user (me)
          // If sender ID matches recipientId, it's from the other person
          final isUserMessage =
              messageData['sender']?['id'] != recipientId.value;
          print(
            '💬 [WebSocket] Message isUser: $isUserMessage, sender: ${messageData['sender']?['id']}, recipientId: ${recipientId.value}',
          );

          _addMessageToList(messageData, isUser: isUserMessage);
        }
      });

      socket!.on('private:error', (error) {
        print('❌ [WebSocket] Error: ${error['message'] ?? error}');
        isConnected.value = false;
        print('❌ [WebSocket] isConnected = false');
      });

      socket!.onDisconnect((_) {
        print('❌ [WebSocket] Disconnected from server');
        isConnected.value = false;
        print('❌ [WebSocket] isConnected = false');
      });

      print('🟡 [_connectWebSocket] Calling socket.connect()');
      socket!.connect();
      print(
        '🟡 [_connectWebSocket] socket.connect() called, waiting for connection...',
      );
    } catch (e) {
      print('❌ [_connectWebSocket] Exception: $e');
      isConnected.value = false;
    }
  }

  void _loadConversations() {
    print('🟡 [_loadConversations] Checking socket connection');
    if (socket != null && socket!.connected) {
      print(
        '🟡 [_loadConversations] Socket connected, emitting private:load_conversations',
      );
      socket!.emit('private:load_conversations');
      print('🟡 [_loadConversations] Emitted private:load_conversations');
    } else {
      print(
        '❌ [_loadConversations] Socket not connected yet. socket=$socket, connected=${socket?.connected}',
      );
    }
  }

  Future<void> _fetchConversationHistory() async {
    print('📡 [_fetchConversationHistory] Fetching conversation history');
    try {
      final response = await ApiClient.to.get('/private-chat');
      print(
        '📡 [_fetchConversationHistory] Response status: ${response.statusCode}',
      );

      if (response.statusCode == 200 && response.body['success'] == true) {
        final conversations = response.body['data'] as List;
        print(
          '📡 [_fetchConversationHistory] Found ${conversations.length} conversations',
        );

        final conversation = conversations.firstWhereOrNull(
          (conv) => conv['participant']?['id'] == recipientId.value,
        );

        if (conversation != null) {
          print(
            '📡 [_fetchConversationHistory] Found conversation with recipientId: ${recipientId.value}',
          );
          conversationId.value = conversation['chatId'];
          print(
            '📡 [_fetchConversationHistory] conversationId set to: ${conversationId.value}',
          );
          await _fetchSingleConversation(conversation['chatId']);
        } else {
          print(
            '⚠️ [_fetchConversationHistory] No conversation found for recipientId: ${recipientId.value}',
          );
        }
      } else {
        print(
          '❌ [_fetchConversationHistory] API error - Status: ${response.statusCode}, Success: ${response.body['success']}',
        );
      }
    } catch (e) {
      print('❌ [_fetchConversationHistory] Exception: $e');
    }
  }

  Future<void> _fetchSingleConversation(String conversationId) async {
    try {
      final response = await ApiClient.to.get('/private-chat/$conversationId');
      print(
        '📡 [_fetchSingleConversation] Response status: ${response.statusCode}',
      );
      print(
        '📡 [_fetchSingleConversation] Full response body: ${response.body}',
      );

      if (response.statusCode == 200) {
        final messageList = response.body['messages'] as List;
        print(
          '📡 [_fetchSingleConversation] Loaded ${messageList.length} messages from history',
        );
        messages.clear();

        for (var msg in messageList) {
          print('📡 [_fetchSingleConversation] RAW message: $msg');
          print(
            '📡 [_fetchSingleConversation] files field: ${msg['files']} (type: ${msg['files']?.runtimeType})',
          );
          print(
            '📡 [_fetchSingleConversation] file field: ${msg['file']} (type: ${msg['file']?.runtimeType})',
          );

          // Ensure files is always a list - handle both 'file' and 'files' fields
          final filesList = <String>[];

          // Check 'files' field (array)
          final filesField = msg['files'];
          if (filesField is List) {
            for (final f in filesField) {
              final fileStr = f?.toString();
              if (fileStr != null && fileStr.isNotEmpty) {
                filesList.add(fileStr);
              }
            }
          } else if (filesField is String && filesField.isNotEmpty) {
            filesList.add(filesField);
          }

          // Check 'file' field (single URL string)
          final singleFile = msg['file'];
          if (singleFile is String && singleFile.isNotEmpty) {
            filesList.add(singleFile);
          }

          print(
            '📡 [_fetchSingleConversation] Message ${msg['id']} has ${filesList.length} files: $filesList',
          );

          messages.add({
            'id': msg['id'],
            'text': msg['content'],
            'isUser': msg['sender']?['id'] != recipientId.value,
            'time': _formatTime(msg['createdAt']),
            'sender': msg['sender'],
            'files': filesList,
          });
        }
        print(
          '📡 [_fetchSingleConversation] Loaded messages with files processed',
        );

        // Scroll to bottom after loading messages
        _scrollToBottom();
      } else {
        print('❌ [_fetchSingleConversation] Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch conversation: $e');
    }
  }

  void sendMessage({List<String>? filePaths}) {
    print(
      '📤 [sendMessage] Attempt to send message, filePaths: ${filePaths?.length ?? 0}',
    );
    final text = textController.text.trim();
    print('📤 [sendMessage] Message text length: ${text.length}');

    if (text.isEmpty && (filePaths == null || filePaths.isEmpty)) {
      print('⚠️ [sendMessage] Empty message and no files, returning');
      return;
    }

    if (filePaths != null && filePaths.isNotEmpty) {
      print('📤 [sendMessage] Sending with files: ${filePaths.length} file(s)');
      _sendMessageWithFiles(text, filePaths);
    } else {
      print('📤 [sendMessage] Sending text message via WebSocket');
      _sendMessageViaSocket(text);
    }

    textController.clear();
    print('📤 [sendMessage] Text controller cleared');
  }

  void _sendMessageViaSocket(String content) {
    print('🔌 [_sendMessageViaSocket] Checking connection status');
    print(
      '🔌 [_sendMessageViaSocket] socket=$socket, connected=${socket?.connected}, isConnected=${isConnected.value}',
    );

    if (socket == null || !socket!.connected) {
      print('❌ [_sendMessageViaSocket] Socket not connected, cannot send');
      return;
    }

    if (recipientId.value == null) {
      print('❌ [_sendMessageViaSocket] recipientId is null');
      return;
    }

    print(
      '🔌 [_sendMessageViaSocket] Sending message to recipientId: ${recipientId.value}',
    );

    socket!.emit('private:send_message', {
      'recipientId': recipientId.value,
      'content': content,
      'replyToMessageId': null,
    });
    print('🔌 [_sendMessageViaSocket] Message emitted');
  }

  Future<void> _sendMessageWithFiles(
    String content,
    List<String> filePaths,
  ) async {
    print(
      '📁 [_sendMessageWithFiles] Starting file upload for ${filePaths.length} file(s)',
    );

    if (recipientId.value == null) {
      print('❌ [_sendMessageWithFiles] recipientId is null');
      return;
    }

    try {
      final recId = recipientId.value!.trim();
      if (recId.isEmpty) {
        print('❌ [_sendMessageWithFiles] recipientId is empty after trim');
        return;
      }

      final token = ApiClient.to.token ?? '';
      final uri = Uri.parse(
        '${Endpoint.baseUrl}/private-chat/send-message/$recId',
      );

      // Backend requires `content` even when sending only files.
      final safeContent = content.trim().isEmpty
          ? 'Attachment'
          : content.trim();

      // Create a temporary optimistic message with local file names
      final nowIso = DateTime.now().toIso8601String();
      final tempId = 'temp-${DateTime.now().millisecondsSinceEpoch}';
      messages.add({
        'id': tempId,
        'text': safeContent,
        'isUser': true,
        'time': _formatTime(nowIso),
        'sender': {'id': 'me'},
        'files': filePaths.map((p) => p.toString()).toList(),
        'isTemp': true,
      });

      // Create multipart request
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['content'] = safeContent
        // Some server implementations validate recipientId from body too.
        ..fields['recipientId'] = recId;

      // Add files to request (field name is "file", not "files")
      for (final filePath in filePaths) {
        print('📁 [_sendMessageWithFiles] Adding file: $filePath');
        final file = File(filePath);
        if (await file.exists()) {
          final multipartFile = await http.MultipartFile.fromPath(
            'file',
            filePath,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        } else {
          print('❌ [_sendMessageWithFiles] File not found: $filePath');
        }
      }

      print('📁 [_sendMessageWithFiles] Sending to ${uri.path}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print(
        '📁 [_sendMessageWithFiles] Response status: ${response.statusCode}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('📁 [_sendMessageWithFiles] File upload successful');
        print('📁 [_sendMessageWithFiles] Response body: ${response.body}');
        // Rely on WebSocket 'private:new_message' to update UI; avoid duplicates
      } else {
        print(
          '❌ [_sendMessageWithFiles] Upload failed - Status: ${response.statusCode}',
        );
        print('❌ [_sendMessageWithFiles] Error response: ${response.body}');
      }
    } catch (e) {
      print('❌ [_sendMessageWithFiles] Exception: $e');
    }
  }

  void _addMessageToList(
    Map<String, dynamic> messageData, {
    required bool isUser,
  }) {
    // Deduplicate based on message id if present
    final msgId = messageData['id']?.toString();
    if (msgId != null && msgId.isNotEmpty) {
      final exists = messages.any((m) => m['id']?.toString() == msgId);
      if (exists) {
        print('⚠️ [_addMessageToList] Duplicate message id "$msgId" skipped');
        return;
      }
    }

    // Robust file extraction: support 'files' (List), 'file' (String)
    final extractedFiles = <String>[];
    final filesField = messageData['files'];
    if (filesField is List) {
      for (final e in filesField) {
        final s = e?.toString();
        if (s != null && s.isNotEmpty) extractedFiles.add(s);
      }
    } else if (filesField is String && filesField.isNotEmpty) {
      extractedFiles.add(filesField);
    }
    final singleFile = messageData['file'];
    if (singleFile is String && singleFile.isNotEmpty) {
      extractedFiles.add(singleFile);
    }

    print(
      '💬 [_addMessageToList] id=${messageData['id']} filesCount=${extractedFiles.length} files=$extractedFiles',
    );

    // Find optimistic temp message and extract its local filenames
    var optimisticFiles = <String>[];
    final tempIndex = messages.indexWhere(
      (m) => (m['isTemp'] == true && m['isUser'] == true),
    );
    if (tempIndex != -1) {
      optimisticFiles = List<String>.from(messages[tempIndex]['files'] ?? []);
      print(
        '🧹 [_addMessageToList] Found temp message with ${optimisticFiles.length} local files',
      );
      messages.removeAt(tempIndex);
    }

    // If server has no files but we have optimistic files, keep them visible
    final finalFiles = extractedFiles.isNotEmpty
        ? extractedFiles
        : optimisticFiles;
    print(
      '💬 [_addMessageToList] Merging: server=${extractedFiles.length}, optimistic=${optimisticFiles.length}, final=${finalFiles.length}',
    );

    messages.add({
      'id': messageData['id'],
      'text': messageData['content'],
      'isUser': isUser,
      'time': _formatTime(messageData['createdAt']),
      'sender': messageData['sender'],
      'files': finalFiles,
    });

    // Scroll to bottom after new message
    _scrollToBottom();
  }

  String _formatTime(String? dateTimeString) {
    if (dateTimeString == null) {
      final now = TimeOfDay.now();
      return "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')}";
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final format = DateFormat('h:mm a');
      return format.format(dateTime);
    } catch (e) {
      final now = TimeOfDay.now();
      return "${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')}";
    }
  }

  void _scrollToBottom() {
    // Delay to ensure ListView has rendered
    Future.delayed(const Duration(milliseconds: 100), () {
      if (chatScrollController.hasClients) {
        chatScrollController.animateTo(
          chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> fetchGarageDetails() async {
    if (garageId == null) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      print(
        'ServiceBookingController: Fetching garage details for ID: $garageId',
      );

      final response = await ApiClient.to.get(
        '${Endpoint.garageDetails}/$garageId',
      );

      print('ServiceBookingController: Response status=${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        if (body != null && body['success'] == true && body['data'] != null) {
          garageDetail.value = GarageDetailModel.fromJson(body['data']);
          print(
            'ServiceBookingController: Garage details loaded: ${garageDetail.value?.name}',
          );

          // Update images with cover photo if available
          if (garageDetail.value?.coverPhoto != null &&
              garageDetail.value!.coverPhoto.isNotEmpty) {
            images.value = [garageDetail.value!.coverPhoto];
          }

          // Update services from API
          if (garageDetail.value?.services != null &&
              garageDetail.value!.services.isNotEmpty) {
            services.value = garageDetail.value!.services.map((serviceName) {
              return {
                "title": serviceName,
                "icon": _getServiceIcon(serviceName),
              };
            }).toList();
          }
        } else {
          print('ServiceBookingController: Invalid response structure');
          hasError.value = true;
        }
      } else {
        print(
          'ServiceBookingController: Failed with status ${response.statusCode}',
        );
        hasError.value = true;
      }
    } catch (e, stackTrace) {
      print('Failed to fetch garage details: $e');
      print('Stack trace: $stackTrace');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  String _getServiceIcon(String serviceName) {
    final lowerName = serviceName.toLowerCase().trim();

    print('Mapping service icon for: "$serviceName" (lowercase: "$lowerName")');

    // AC & Air Conditioning
    if (lowerName.contains('ac') ||
        lowerName.contains('air') ||
        lowerName.contains('conditioning') ||
        lowerName.contains('cooling')) {
      return Iconpath.acIcon;
    }
    // Battery
    else if (lowerName.contains('battery') || lowerName.contains('batteries')) {
      return Iconpath.batterryIcon;
    }
    // Tires & Wheels
    else if (lowerName.contains('tire') ||
        lowerName.contains('tyre') ||
        lowerName.contains('wheel')) {
      return Iconpath.tire;
    }
    // Engine
    else if (lowerName.contains('engine') ||
        lowerName.contains('motor') ||
        lowerName.contains('diagnostic')) {
      return Iconpath.engineIcon;
    }
    // Electrical
    else if (lowerName.contains('electric') ||
        lowerName.contains('wiring') ||
        lowerName.contains('lighting')) {
      return Iconpath.electricIcon;
    }
    // Brakes
    else if (lowerName.contains('brake') || lowerName.contains('braking')) {
      return Iconpath.tire; // Using tire icon for brakes as fallback
    }
    // Oil
    else if (lowerName.contains('oil') ||
        lowerName.contains('fluid') ||
        lowerName.contains('lubrication')) {
      return Iconpath.engineIcon; // Using engine icon for oil
    }
    // Spare parts
    else if (lowerName.contains('spare') || lowerName.contains('part')) {
      return Iconpath.spareIcon;
    }
    // Default - cycle through icons to avoid all being the same
    else {
      // Use hash of service name to pick different icons
      final hashCode = serviceName.hashCode.abs();
      final icons = [
        Iconpath.acIcon,
        Iconpath.batterryIcon,
        Iconpath.tire,
        Iconpath.engineIcon,
        Iconpath.electricIcon,
        Iconpath.spareIcon,
      ];
      final selectedIcon = icons[hashCode % icons.length];
      print(
        'Using fallback icon for "$serviceName": index ${hashCode % icons.length}',
      );
      return selectedIcon;
    }
  }
}
