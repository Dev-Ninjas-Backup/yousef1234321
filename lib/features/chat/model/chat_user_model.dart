class ChatUserModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;

  ChatUserModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
  });
}
