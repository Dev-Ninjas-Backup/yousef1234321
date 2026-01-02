// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:yousef1234321/core/network/api_client.dart';
import '../model/chat_user_model.dart';

class ChatPageController extends GetxController {
  RxList<ChatUserModel> chatList = <ChatUserModel>[].obs;
  RxList<ChatUserModel> filteredChatList = <ChatUserModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔵 [ChatPageController] onInit called');
    loadConversations();
    print('🔵 [ChatPageController] loadConversations() triggered');
  }

  Future<void> loadConversations() async {
    print('\n\n═══════════════════════════════════════════════════');
    print('📞 [loadConversations] Method called - START');
    print('═══════════════════════════════════════════════════\n');
    try {
      isLoading.value = true;
      print('🔄 [ChatPageController] Loading conversations...');
      print('🔄 [ChatPageController] isLoading set to true');

      print('📡 [ChatPageController] Making API call to /private-chat...');
      final response = await ApiClient.to.get('/private-chat');
      print('📡 [ChatPageController] API ENDPOINT: GET /private-chat');
      print('📡 [ChatPageController] API Response received');
      print('📡 [ChatPageController] Status Code: ${response.statusCode}');
      print(
        '📡 [ChatPageController] Response Body Type: ${response.body.runtimeType}',
      );
      print('\n╔════════════════════════════════════════════════════╗');
      print('║           FULL RESPONSE START                      ║');
      print('╚════════════════════════════════════════════════════╝');
      print('${response.body}');
      print('╔════════════════════════════════════════════════════╗');
      print('║           FULL RESPONSE END                        ║');
      print('╚════════════════════════════════════════════════════╝\n');

      if (response.statusCode == 200) {
        print('✅ [ChatPageController] Status 200 confirmed');

        final success = response.body['success'];
        print('📡 [ChatPageController] Success field: $success');

        if (success == true) {
          print('✅ [ChatPageController] Success is true');

          final data = response.body['data'];
          print('📡 [ChatPageController] Data field type: ${data.runtimeType}');
          print('📡 [ChatPageController] Data field: $data');

          if (data is List) {
            final conversations = data;
            print(
              '📡 [ChatPageController] Loaded ${conversations.length} conversations',
            );

            final List<ChatUserModel> users = [];

            for (int i = 0; i < conversations.length; i++) {
              try {
                final conv = conversations[i];
                print(
                  '📋 [ChatPageController] Processing conversation $i: $conv',
                );

                final participant = conv['participant'];
                print(
                  '👤 [ChatPageController] Participant for $i: $participant',
                );

                if (participant != null) {
                  final userId = participant['id'] ?? '';
                  final fullName = participant['fullName'] ?? 'Unknown User';

                  // lastMessage is a Map object, extract content from it
                  final lastMessageObj = conv['lastMessage'];
                  String lastMsg = 'No messages yet';
                  String? lastMsgTime;
                  if (lastMessageObj is Map) {
                    lastMsg = lastMessageObj['content'] ?? 'No messages yet';
                    lastMsgTime = lastMessageObj['createdAt'];
                  } else if (lastMessageObj is String) {
                    lastMsg = lastMessageObj;
                  }

                  print(
                    '👤 [ChatPageController] Extracted - ID: $userId, Name: $fullName, LastMsg: $lastMsg',
                  );

                  final user = ChatUserModel(
                    id: userId,
                    name: fullName,
                    lastMessage: lastMsg,
                    time: _formatTime(
                      lastMsgTime ?? conv['updatedAt'] ?? DateTime.now(),
                    ),
                    imageUrl:
                        participant['profilePhoto'] ??
                        'https://i.pravatar.cc/150?img=${users.length}',
                    unreadCount: conv['unreadCount'] ?? 0,
                  );
                  users.add(user);
                  print(
                    '✅ [ChatPageController] Added user: ${user.name} (${user.id})',
                  );
                } else {
                  print(
                    '⚠️ [ChatPageController] Participant is null for conversation $i',
                  );
                }
              } catch (e) {
                print('❌ [ChatPageController] Error parsing conversation: $e');
                print(
                  '❌ [ChatPageController] Stack trace: ${StackTrace.current}',
                );
              }
            }

            chatList.value = users;
            filteredChatList.value = users;
            print(
              '✅ [ChatPageController] Successfully loaded ${users.length} users',
            );
            print(
              '✅ [ChatPageController] chatList.length = ${chatList.length}',
            );
            print(
              '✅ [ChatPageController] filteredChatList.length = ${filteredChatList.length}',
            );
          } else {
            print(
              '❌ [ChatPageController] Data is not a List, it is ${data.runtimeType}',
            );
          }
        } else {
          print('❌ [ChatPageController] Success is not true: $success');
        }
      } else {
        print(
          '❌ [ChatPageController] API error status: ${response.statusCode}',
        );
        print('❌ [ChatPageController] Response: ${response.body}');
      }
    } catch (e) {
      print('❌ [ChatPageController] Exception: $e');
      print('❌ [ChatPageController] Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
      print('🔄 [ChatPageController] isLoading set to false');
      print('📞 [loadConversations] Method finished - END');
    }
  }

  String _formatTime(dynamic dateTime) {
    try {
      if (dateTime == null) return 'Now';

      if (dateTime is String) {
        dateTime = DateTime.parse(dateTime);
      }

      if (dateTime is! DateTime) {
        return 'Now';
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'just_now'.tr;
      } else if (difference.inMinutes < 60) {
        return 'min_ago'.trParams({'min': difference.inMinutes.toString()});
      } else if (difference.inHours < 24) {
        return 'hr_ago'.trParams({'hr': difference.inHours.toString()});
      } else if (difference.inDays < 7) {
        return 'day_ago'.trParams({'day': difference.inDays.toString()});
      } else {
        return '${dateTime.day} ${_monthName(dateTime.month)}, ${dateTime.year}';
      }
    } catch (e) {
      return 'Now';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void filterChats(String query) {
    if (query.isEmpty) {
      filteredChatList.value = chatList;
    } else {
      filteredChatList.value = chatList
          .where(
            (chat) =>
                chat.name.toLowerCase().contains(query.toLowerCase().trim()),
          )
          .toList();
    }
  }
}
