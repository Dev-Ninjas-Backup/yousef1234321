import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:yousef1234321/features/support/controller/support_controller.dart';

class ChatPage extends StatelessWidget {
  final controller = Get.put(ChatController());

  ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 52, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 44),
                Column(
                  spacing: 2,
                  children: [
                    Text(
                      "Chat",
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Active Now",
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF19B000),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 44),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isUser = message['isUser'] ?? false;

                  // Message Row (with optional avatar)
                  return Row(
                    mainAxisAlignment: isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Profile image (only for receiver)
                      if (!isUser) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            8,
                          ), // or Circle if you prefer
                          child: Icon(Icons.person, size: 32),
                        ),
                        const SizedBox(width: 8),
                      ],

                      // Message bubble
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blue.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isUser ? 16 : 0),
                              bottomRight: Radius.circular(isUser ? 0 : 16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Message Text
                              Text(
                                message['text'] ?? '',
                                style: getTextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // Time + Delivered Icon
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: isUser
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Text(
                                    message['time'] ?? '',
                                    style: getTextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (isUser) ...[
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.done_all,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Typing indicator
          // Obx(
          //   () => controller.isTyping.value
          //       ? Padding(
          //           padding: const EdgeInsets.only(left: 16, bottom: 8),
          //           child: Row(
          //             children: [
          //               const CircleAvatar(
          //                 radius: 14,
          //                 backgroundColor: Colors.amber,
          //                 child: Icon(
          //                   Icons.support_agent,
          //                   color: Colors.white,
          //                   size: 16,
          //                 ),
          //               ),
          //               const SizedBox(width: 8),
          //               Container(
          //                 padding: const EdgeInsets.all(8),
          //                 decoration: BoxDecoration(
          //                   color: Colors.grey.shade100,
          //                   borderRadius: BorderRadius.circular(16),
          //                 ),
          //                 child: const Text("Typing..."),
          //               ),
          //             ],
          //           ),
          //         )
          //       : const SizedBox.shrink(),
          // ),

          // Message Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textController,
                    decoration: InputDecoration(
                      hintText: "Type your message",
                      hintStyle: const TextStyle(fontSize: 15),
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: Icon(Icons.attach_file),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: controller.sendMessage,
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
