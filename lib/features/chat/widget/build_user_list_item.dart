// chat/widget/chat_widget.dart
import 'package:flutter/material.dart';
import '../model/chat_user_model.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';

class ChatTile extends StatelessWidget {
  final ChatUserModel chat;
  final VoidCallback? onTap;

  const ChatTile({super.key, required this.chat, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            backgroundImage: chat.isInitial
                ? null
                : NetworkImage(chat.imageUrl),
            child: chat.isInitial
                ? Text(
                    chat.initial ?? '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          if (chat.unreadCount > 0)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  chat.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: TranslatedText(text: chat.time),
      onTap: onTap,
    );
  }
}
