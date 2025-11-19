import 'package:get/get.dart';
import '../model/chat_user_model.dart';

class ChatPageController extends GetxController {
  RxList<ChatUserModel> chatList = <ChatUserModel>[].obs;
  RxList<ChatUserModel> filteredChatList = <ChatUserModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    chatList.value = [
      ChatUserModel(
        name: "John Xaria",
        lastMessage: "Hey! Are you coming today?",
        time: "Just now",
        imageUrl: "https://i.pravatar.cc/150?img=1",
        unreadCount: 1,
      ),
      ChatUserModel(
        name: "Nancy Sufea",
        lastMessage: "Let's meet tomorrow.",
        time: "2m ago",
        imageUrl: "https://i.pravatar.cc/150?img=2",
      ),
      ChatUserModel(
        name: "Rocky",
        lastMessage: "Okay, noted!",
        time: "2 days ago",
        imageUrl: "https://i.pravatar.cc/150?img=3",
      ),
      ChatUserModel(
        name: "Foysal",
        lastMessage: "Thank you!",
        time: "12 Jul, 25",
        imageUrl: "https://i.pravatar.cc/150?img=4",
        unreadCount: 2,
      ),
    ];

    filteredChatList.value = chatList;
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
