// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/service/service_booking/controller/service_booking_controller.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/service_message.dart';
import 'package:yousef1234321/core/service/translation_service.dart';
import '../controller/chat_page_controller.dart';
import '../widget/build_user_list_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late final ChatPageController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('\n════════════════════════════════════════════════════');
    print('🟦 [ChatScreen] initState() called');
    print('════════════════════════════════════════════════════\n');

    // Use Get.find if exists, otherwise create new
    if (Get.isRegistered<ChatPageController>()) {
      print('🟦 [ChatScreen] Found existing ChatPageController');
      controller = Get.find<ChatPageController>();
    } else {
      print('🟦 [ChatScreen] Creating new ChatPageController');
      controller = Get.put(ChatPageController());
    }

    print('🟦 [ChatScreen] Calling loadConversations()...');
    controller.loadConversations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('🟦 [ChatScreen] App resumed, refreshing conversations');
      controller.loadConversations();
    }
  }

  // Called when this screen becomes visible again after navigation
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh conversations when screen becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print(
          '🟦 [ChatScreen] didChangeDependencies - refreshing conversations',
        );
        controller.loadConversations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('\n🎨 [ChatScreen] build() called');
    print('🎨 [ChatScreen] controller instance: ${controller.runtimeType}');
    print(
      '🎨 [ChatScreen] controller.chatList.length: ${controller.chatList.length}',
    );

    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Title
            CustomAppBar(title: "chat"),
            const SizedBox(height: 12), // Reduced gap
            /// 🔍 Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: FutureBuilder<String>(
                future: () async {
                  // Resolve 'search' key to English text 'Search' then translate
                  String text = "search";
                  final englishMap = Get.translations['en_US'];
                  if (englishMap != null && englishMap.containsKey(text)) {
                    text = englishMap[text]!;
                  }
                  return Get.find<TranslationService>().translate(text);
                }(),
                initialData: "Search",
                builder: (context, snapshot) {
                  return TextField(
                    decoration: InputDecoration(
                      hintText: snapshot.data,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onChanged: (value) => controller.filterChats(value),
                  );
                },
              ),
            ),

            const SizedBox(height: 4), // Gap almost removed
            /// 🗨 Chat List
            Expanded(
              child: Obx(() {
                print(
                  '🎨 [ChatScreen] Building list - isLoading: ${controller.isLoading.value}',
                );
                print(
                  '🎨 [ChatScreen] filteredChatList.length: ${controller.filteredChatList.length}',
                );
                print(
                  '🎨 [ChatScreen] chatList.length: ${controller.chatList.length}',
                );

                if (controller.isLoading.value) {
                  print('🎨 [ChatScreen] Showing loading indicator');
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.filteredChatList.isEmpty) {
                  print(
                    '🎨 [ChatScreen] Chat list is empty, showing no conversations message',
                  );
                  return Center(
                    child: TranslatedText(text: 'no_conversations'),
                  );
                }

                print(
                  '🎨 [ChatScreen] Rendering ${controller.filteredChatList.length} chats',
                );
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.filteredChatList.length,
                  itemBuilder: (context, index) {
                    final chat = controller.filteredChatList[index];
                    print(
                      '🎨 [ChatScreen] Building chat item $index: ${chat.name}',
                    );
                    return ChatTile(
                      chat: chat,
                      onTap: () {
                        /// Navigate to message screen with recipient ID
                        final recipientId = chat.id;
                        print(
                          '💬 [ChatList] Opening chat with recipient: $recipientId (${chat.name})',
                        );

                        Get.find<ServiceBookingController>().initializeChat(
                          recipientId,
                        ); // Initialize chat for this recipient
                        Get.to(() => ServiceMessage(recipientId: recipientId));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
