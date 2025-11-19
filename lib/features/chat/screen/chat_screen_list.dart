// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
// import '../controller/chat_page_controller.dart';
// import '../widget/build_user_list_item.dart';

// class ChatScreen extends StatelessWidget {
//   ChatScreen({super.key});

//   final ChatPageController controller = Get.put(ChatPageController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 52),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CustomAppBar(title: "Chat"),
//             const SizedBox(height: 16),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF2F2F2),
//                 borderRadius: BorderRadius.circular(25),
//               ),
//               child: TextField(
//                 decoration: const InputDecoration(
//                   hintText: "Search",
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onChanged: (value) => controller.filterChats(value),
//               ),
//             ),

//             const SizedBox(height: 20),
//             Expanded(
//               child: Obx(
//                 () => ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: controller.filteredChatList.length,
//                   itemBuilder: (context, index) {
//                     final chat = controller.filteredChatList[index];
//                     return ChatTile(
//                       chat: chat,
//                       onTap: () {
//                         Get.snackbar("Chat", "Open chat with ${chat.name}");
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/service_message.dart';
import '../controller/chat_page_controller.dart';
import '../widget/build_user_list_item.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  final ChatPageController controller = Get.put(ChatPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header Title
            CustomAppBar(title: "Chat"),
            const SizedBox(height: 12), // Reduced gap
            /// 🔍 Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (value) => controller.filterChats(value),
              ),
            ),

            const SizedBox(height: 4), // Gap almost removed
            /// 🗨 Chat List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.filteredChatList.length,
                  itemBuilder: (context, index) {
                    final chat = controller.filteredChatList[index];
                    return ChatTile(
                      chat: chat,
                      onTap: () {
                        /// Navigate to message screen
                        Get.to(
                          () => ServiceMessage(
                            // user: chat, // OPTIONAL: Pass user object
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
