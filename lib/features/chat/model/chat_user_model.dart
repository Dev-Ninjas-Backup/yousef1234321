class ChatUserModel {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final String? initial; // First letter of name if no profile photo

  ChatUserModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.initial,
  });

  /// Check if displaying initial instead of image
  bool get isInitial => initial != null;
}
