// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/endpoint/endpoint.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import 'package:yousef1234321/features/service/service_booking/model/garage_detail_model.dart';
import 'package:yousef1234321/features/chat/controller/chat_page_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ServiceBookingController extends GetxController {
  ServiceBookingController() {
    print('🏗️ [ServiceBookingController] Constructor called');
  }

  final Rx<GarageDetailModel?> garageDetail = Rx<GarageDetailModel?>(null);
  final isLoading = false.obs;
  final hasError = false.obs;
  String? garageId;
  
  /// Get the current garage ID
  String? get currentGarageId => garageId;
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

  var services = <Map<String, dynamic>>[
    {"title": "ac_service", "icon": Iconpath.acIcon},
    {"title": "battery_replacement", "icon": Iconpath.batterryIcon},
    {"title": "tires", "icon": Iconpath.tire},
    {"title": "engine_diagnostics", "icon": Iconpath.engineIcon},
    {"title": "electrical", "icon": Iconpath.electricIcon},
    {"title": "spares", "icon": Iconpath.spareIcon},
  ].obs;
  var isOpen = true.obs;

  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    print('🚀 [ServiceBookingController.onInit] onInit called');
    pageController = PageController(initialPage: 0);
    loadInitialMessages();

    // Get garage ID from arguments
    final args = Get.arguments;
    if (args != null && args is Map && args['garageId'] != null) {
      garageId = args['garageId'];
      fetchGarageDetails();
    } else {
      fetchServices();
    print('🔍 [ServiceBookingController.onInit] Arguments received: $args');
    print('🔍 [ServiceBookingController.onInit] Arguments type: ${args.runtimeType}');
    
    if (args != null && args is Map) {
      print('🔍 [ServiceBookingController.onInit] Arguments keys: ${args.keys}');
      print('🔍 [ServiceBookingController.onInit] garageId value: ${args['garageId']}');
      print('🔍 [ServiceBookingController.onInit] garageId type: ${args['garageId'].runtimeType}');
      
      if (args['garageId'] != null) {
        garageId = args['garageId'].toString();
        print('✅ [ServiceBookingController.onInit] garageId set to: $garageId');
        fetchGarageDetails();
      } else {
        print('❌ [ServiceBookingController.onInit] garageId is null in arguments');
      }
    } else {
      print('❌ [ServiceBookingController.onInit] Arguments are null or not a Map!');
      print('❌ [ServiceBookingController.onInit] Args: $args');
      print('❌ [ServiceBookingController.onInit] Cannot load garage details without garageId');
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

  /// Set garage ID and fetch details - useful when navigating programmatically
  void setGarageId(String id) {
    print('🆔 [setGarageId] Setting garageId to: $id');
    garageId = id;
    fetchGarageDetails();
  }

  /// Clear garage data - useful when navigating between different garages
  void clearGarageData() {
    print('🧹 [clearGarageData] Clearing garage data');
    garageDetail.value = null;
    garageId = null;
    hasError.value = false;
    isLoading.value = false;
  }

  // Service messaging - Real-time Chat with WebSocket & REST API
  var messages = <Map<String, dynamic>>[].obs;
  var isTyping = false.obs;
  var isConnected = false.obs;
  var recipientId = RxnString();
  var conversationId = RxnString();
  var otherParticipantName = RxnString(); // Store the name of the other participant
  var conversationParticipants = <Map<String, dynamic>>[].obs; // Store all participants
  TextEditingController textController = TextEditingController();
  ScrollController chatScrollController = ScrollController();
  IO.Socket? socket;

  void loadInitialMessages() {
    if (recipientId.value != null) {
      _fetchConversationHistory();
    }
  }

  /// Refresh the chat page controller to show new conversations in the chat list
  void _refreshChatList() {
    try {
      if (Get.isRegistered<ChatPageController>()) {
        print(
          '🔄 [_refreshChatList] ✅ ChatPageController found, calling loadConversations()',
        );
        final chatController = Get.find<ChatPageController>();
        chatController.loadConversations();
        print(
          '🔄 [_refreshChatList] ✅ loadConversations() called successfully',
        );
      } else {
        print('⚠️ [_refreshChatList] ❌ ChatPageController not registered yet');
        print(
          '⚠️ [_refreshChatList] This might happen if user hasn\'t opened ChatScreen yet',
        );
      }
    } catch (e) {
      print('❌ [_refreshChatList] Exception occurred: $e');
      print('❌ [_refreshChatList] Stack trace: ${e.toString()}');
    }
  }

  void initializeChat(String? recId) {
    print(
      '🔵 [initializeChat] Starting chat initialization with recipientId: $recId',
    );
    print('🔵 [initializeChat] recipientId type: ${recId.runtimeType}');
    print('🔵 [initializeChat] recipientId length: ${recId?.length}');

    // Clear messages and reset state when switching conversations
    if (recipientId.value != recId) {
      print('🔵 [initializeChat] RecipientId changed, clearing messages');
      print('🔵 [initializeChat] Old recipientId: ${recipientId.value}');
      print('🔵 [initializeChat] New recipientId: $recId');
      messages.clear();
      conversationId.value = null;
    }

    recipientId.value = recId;
    print('🔵 [initializeChat] recipientId set to: ${recipientId.value}');
    loadInitialMessages();
    print('🔵 [initializeChat] loadInitialMessages called');
    _connectWebSocket();
    print('🔵 [initializeChat] _connectWebSocket called');
  }

  void _connectWebSocket() {
    try {
      print('� [_connectWebSocket] Starting WebSocket connection');

      // Disconnect existing socket before creating a new one
      if (socket != null) {
        print('� [_connectWebSocket] Disconnecting existing socket');
        socket!.disconnect();
        socket = null;
      }

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

          // Set conversationId when server provides it (e.g., first message in new chat)
          final serverConvId = messageData['conversationId']?.toString();
          if (serverConvId != null && serverConvId.isNotEmpty) {
            if (conversationId.value != serverConvId) {
              print(
                '💬 [WebSocket] ✅ NEW CONVERSATION CREATED! conversationId: $serverConvId',
              );
              print(
                '💬 [WebSocket] Previous conversationId was: ${conversationId.value}',
              );
              conversationId.value = serverConvId;
              print(
                '💬 [WebSocket] conversationId updated to: ${conversationId.value}',
              );
            }
          }
          // Determine if this message is from the user or the other person
          // If sender ID is different from recipientId, it's from the user (me)
          // If sender ID matches recipientId, it's from the other person
          final isUserMessage =
              messageData['sender']?['id'] != recipientId.value;
          print(
            '💬 [WebSocket] Message isUser: $isUserMessage, sender: ${messageData['sender']?['id']}, recipientId: ${recipientId.value}',
          );

          _addMessageToList(messageData, isUser: isUserMessage);

          // Refresh chat list when new messages are received to ensure conversations appear in the list
          _refreshChatList();
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

      socket!.onError((error) {
        print('❌ [WebSocket] Connection error: $error');
        isConnected.value = false;
      });

      socket!.on('connect_error', (error) {
        print('❌ [WebSocket] Connect error: $error');
        isConnected.value = false;
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
        print(
          '📡 [_fetchConversationHistory] Looking for recipientId: ${recipientId.value}',
        );

        // Debug: Print all participant IDs
        for (int i = 0; i < conversations.length; i++) {
          final conv = conversations[i];
          final participantId = conv['participant']?['id'];
          final participantName = conv['participant']?['name'];
          print(
            '📡 [_fetchConversationHistory] Conversation $i: participantId=$participantId, name=$participantName',
          );
        }

        final conversation = conversations.firstWhereOrNull(
          (conv) => conv['participant']?['id'] == recipientId.value,
        );

        if (conversation != null) {
          print(
            '📡 [_fetchConversationHistory] ✅ Found conversation with recipientId: ${recipientId.value}',
          );
          conversationId.value = conversation['chatId'];
          print(
            '📡 [_fetchConversationHistory] conversationId set to: ${conversationId.value}',
          );
          await _fetchSingleConversation(conversation['chatId']);
        } else {
          print(
            '⚠️ [_fetchConversationHistory] ❌ No conversation found for recipientId: ${recipientId.value}',
          );
          print(
            '⚠️ [_fetchConversationHistory] This means we\'ll create a new conversation when first message is sent',
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
        // Extract and store participants
        final participants = response.body['participants'] as List? ?? [];
        conversationParticipants.value = participants.cast<Map<String, dynamic>>();
        
        // Find the other participant (not the current user)
        final currentUserId = ApiClient.to.userId;
        print('📡 [_fetchSingleConversation] Current user ID: $currentUserId');
        
        final otherParticipant = participants.firstWhereOrNull(
          (p) => p['id'] != currentUserId,
        );
        
        if (otherParticipant != null) {
          otherParticipantName.value = otherParticipant['fullName'] ?? 'Unknown User';
          print(
            '📡 [_fetchSingleConversation] Other participant: ${otherParticipantName.value}',
          );
        } else {
          print('⚠️ [_fetchSingleConversation] Could not find other participant');
        }

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
    print('\n\n');
    print('═══════════════════════════════════════════════════════');
    print('📤 [sendMessage] SEND MESSAGE CALLED');
    print('═══════════════════════════════════════════════════════');
    print('recipientId: ${recipientId.value}');
    print('recipientId is null: ${recipientId.value == null}');
    print('conversationId: ${conversationId.value}');
    print('filePaths count: ${filePaths?.length ?? 0}');
    print('socket exists: ${socket != null}');
    print('socket connected: ${socket?.connected ?? false}');
    print('isConnected.value: ${isConnected.value}');

    final text = textController.text.trim();
    print('Message text length: ${text.length}');
    print('Message text: "$text"');
    print('═══════════════════════════════════════════════════════\n');

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
    print('\n\n');
    print('─────────────────────────────────────────────────────────');
    print('🔌 [_sendMessageViaSocket] WEBSOCKET SEND ATTEMPT');
    print('─────────────────────────────────────────────────────────');
    print('socket is null: ${socket == null}');
    print('socket connected: ${socket?.connected}');
    print('isConnected.value: ${isConnected.value}');
    print('recipientId.value: ${recipientId.value}');
    print('content length: ${content.length}');
    print('─────────────────────────────────────────────────────────\n');

    if (socket == null || !socket!.connected) {
      print('❌ [_sendMessageViaSocket] ❌ Socket not connected!');
      print('⚠️ [_sendMessageViaSocket] Will fallback to REST API after delay');
      return;
    }

    if (recipientId.value == null) {
      print('❌ [_sendMessageViaSocket] recipientId is null!');
      return;
    }

    // Add optimistic message to UI immediately
    print('💬 [_sendMessageViaSocket] Adding optimistic message to UI');
    messages.add({
      'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
      'text': content,
      'isUser': true,
      'time': _formatTime(DateTime.now().toIso8601String()),
      'isTemp': true,
      'files': [],
    });
    _scrollToBottom();

    print(
      '✅ [_sendMessageViaSocket] Sending WebSocket message to recipientId: ${recipientId.value}',
    );

    socket!.emit('private:send_message', {
      'recipientId': recipientId.value,
      'content': content,
      'replyToMessageId': null,
    });
    print('✅ [_sendMessageViaSocket] ✉️ Message emitted to WebSocket');

    // If conversation was just created server-side, fetch history soon
    Future.delayed(const Duration(milliseconds: 500), () {
      // Only refetch if we don't yet have a conversationId
      if (conversationId.value == null || conversationId.value!.isEmpty) {
        print(
          '📡 [_sendMessageViaSocket] No conversationId yet, refetching history',
        );
        _fetchConversationHistory();
      }
    });

    // Fallback: if still no conversation id shortly after, use REST send
    Future.delayed(const Duration(seconds: 1), () async {
      if (conversationId.value == null || conversationId.value!.isEmpty) {
        print('📡 [_sendMessageViaSocket] ⚠️ Fallback to REST send for text');
        await _sendTextMessageViaRest(content);
        // Refetch to capture new conversation and messages
        await Future.delayed(const Duration(milliseconds: 400));
        _fetchConversationHistory();
        // Refresh chat list to show new conversation
        _refreshChatList();
      }
    });

    // Always refresh chat list after sending a message to ensure it appears in the list
    Future.delayed(const Duration(milliseconds: 1500), () {
      _refreshChatList();
    });
  }

  Future<void> _sendTextMessageViaRest(String content) async {
    if (recipientId.value == null) {
      print('❌ [_sendTextMessageViaRest] recipientId is null');
      return;
    }
    try {
      final recId = recipientId.value!.trim();
      if (recId.isEmpty) {
        print('❌ [_sendTextMessageViaRest] recipientId is empty after trim');
        return;
      }

      print(
        '📡 [_sendTextMessageViaRest] 🚀 Starting REST message send to recipientId: $recId',
      );
      final uri = Uri.parse(
        '${Endpoint.baseUrl}/private-chat/send-message/$recId',
      );
      final token = ApiClient.to.token ?? '';
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['content'] = content;
      request.fields['recipientId'] = recId;

      print('📡 [_sendTextMessageViaRest] POST ${request.url}');
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      print('📡 [_sendTextMessageViaRest] Status: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
          '✅ [_sendTextMessageViaRest] 🎉 Text message sent via REST successfully!',
        );
        print('✅ [_sendTextMessageViaRest] Response body: ${response.body}');
        // Refresh chat list after successful message send
        print('🔄 [_sendTextMessageViaRest] Calling _refreshChatList()...');
        _refreshChatList();
      } else {
        print('❌ [_sendTextMessageViaRest] Failed: ${response.body}');
      }
    } catch (e) {
      print('❌ [_sendTextMessageViaRest] Exception: $e');
    }
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
        ..fields['recipientId'] = recId
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
        // Refresh chat list after successful file upload
        _refreshChatList();
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
      final format = DateFormat('h:mm a', Get.locale?.languageCode);
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
    print('🔍 [fetchGarageDetails] Called with garageId: $garageId');
    
    if (garageId == null) {
      print('❌ [fetchGarageDetails] garageId is null, returning');
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;
      print(
        '📡 [fetchGarageDetails] Fetching garage details for ID: $garageId',
      );

      final endpoint = '${Endpoint.garageDetails}/$garageId';
      print('📡 [fetchGarageDetails] Using endpoint: $endpoint');

      final response = await ApiClient.to.get(endpoint);

      print('📡 [fetchGarageDetails] Response status=${response.statusCode}');
      print('📡 [fetchGarageDetails] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        print('📡 [fetchGarageDetails] Response body structure: ${body?.keys}');
        print('📡 [fetchGarageDetails] Success field: ${body?['success']}');
        print('📡 [fetchGarageDetails] Data field exists: ${body?['data'] != null}');
        
        if (body != null && body['success'] == true && body['data'] != null) {
          print('📡 [fetchGarageDetails] Attempting to parse GarageDetailModel...');
          try {
            garageDetail.value = GarageDetailModel.fromJson(body['data']);
            print(
              '✅ [fetchGarageDetails] Garage details loaded: ${garageDetail.value?.name}',
            );
            print(
              '✅ [fetchGarageDetails] User data: ${garageDetail.value?.user}',
            );
            print(
              '✅ [fetchGarageDetails] UserId: ${garageDetail.value?.userId}',
            );
          } catch (parseError, parseStack) {
            print('❌ [fetchGarageDetails] Model parsing failed: $parseError');
            print('❌ [fetchGarageDetails] Parse stack: $parseStack');
            hasError.value = true;
            return;
          }

          // Update images with cover photo if available
          if (garageDetail.value?.coverPhoto != null &&
              garageDetail.value!.coverPhoto.isNotEmpty) {
            images.value = [garageDetail.value!.coverPhoto];
          }

          // Update services from API
          if (garageDetail.value?.services != null &&
              garageDetail.value!.services.isNotEmpty) {
            print(
              '✅ Garage specific services found: ${garageDetail.value!.services.length}',
            );
            services.value = garageDetail.value!.services.map((item) {
              final serviceName = item.toString();
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

  Future<void> fetchServices() async {
    try {
      print('📡 Fetching global services list...');
      // Fetching services from backend API: /services
      final response = await ApiClient.to.get('/services');
      print('📡 Services API Status: ${response.statusCode}');

      if (response.statusCode == 200 && response.body['success'] == true) {
        final data = response.body['data'];
        if (data is List) {
          final fetchedServices = data.map((item) {
            final name = (item is Map ? item['name'] ?? '' : item.toString())
                .toString();
            return {"title": name, "icon": _getServiceIcon(name)};
          }).toList();

          if (fetchedServices.isNotEmpty) {
            services.value = fetchedServices;
            print('✅ Global services loaded: ${services.length}');
          }
        }
      }
    } catch (e) {
      print('Error fetching services: $e');
    }
  }

  String mapServiceToKey(String serviceName) {
    final lower = serviceName.toLowerCase();
    if (lower.contains('ac') || lower.contains('air')) return 'ac_service';
    if (lower.contains('battery')) return 'battery_replacement';
    if (lower.contains('tire') || lower.contains('wheel')) return 'tires';
    if (lower.contains('engine')) return 'engine_diagnostics';
    if (lower.contains('electric')) return 'electrical';
    if (lower.contains('spare')) return 'spares';
    if (lower.contains('brake')) return 'brakes';
    if (lower.contains('body')) return 'body_work';

    // Fallback: return the original name if no key matches.
    // The UI should handle this gracefully (e.g. 'Some Name'.tr returns 'Some Name' if key missing)
    // Or we can return a generic key.
    // For now, returning the name allows it to be displayed as-is if not translated.
    // However, to force localization, we should try to match as many as possible.

    return serviceName;
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
