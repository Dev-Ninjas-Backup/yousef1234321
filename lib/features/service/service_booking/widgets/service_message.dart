// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/core/common/style/global_text_style.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../controller/service_booking_controller.dart';

class ServiceMessage extends StatelessWidget {
  final controller = Get.put(ServiceBookingController());
  final String? recipientId;
  final selectedFiles = <PlatformFile>[].obs;

  String _fileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) return segments.last;
    } catch (_) {}
    // Fallback for plain file paths
    final parts = url.split('/');
    if (parts.isNotEmpty) return parts.last;
    return url;
  }

  String _fileExtensionFromUrl(String url) {
    final name = _fileNameFromUrl(url);
    final dot = name.lastIndexOf('.');
    if (dot == -1 || dot == name.length - 1) return '';
    return name.substring(dot + 1).toUpperCase();
  }

  Widget _attachmentRow(String url) {
    final fileName = _fileNameFromUrl(url);
    final ext = _fileExtensionFromUrl(url);
    final typeLabel = ext.isEmpty ? 'FILE' : ext;
    final isHttp = url.startsWith('http://') || url.startsWith('https://');

    return InkWell(
      onTap: isHttp ? () => _downloadOrOpenFile(url) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.attach_file, size: 16),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getTextStyle(fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    typeLabel,
                    style: getTextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.download,
              size: 16,
              color: isHttp ? Colors.black : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadOrOpenFile(String url) async {
    try {
      Get.snackbar(
        'Downloading',
        'Starting download...',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );

      // Download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the downloads directory
        final directory = await getDownloadsDirectory();
        if (directory == null) {
          Get.snackbar(
            'Error',
            'Downloads directory not available',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Extract filename from URL
        final fileName = _fileNameFromUrl(url);
        final filePath = '${directory.path}/$fileName';

        // Write file to downloads
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        Get.snackbar(
          'Success',
          'File downloaded to Downloads folder',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Download failed',
          'Server returned status ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Download failed',
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  ServiceMessage({super.key, this.recipientId}) {
    // Initialize chat with recipient ID
    print(
      '🟦 [ServiceMessage Constructor] Widget created with recipientId: $recipientId',
    );
    if (recipientId != null) {
      print('🟦 [ServiceMessage Constructor] Initializing chat...');
      controller.initializeChat(recipientId);
    } else {
      print('⚠️ [ServiceMessage Constructor] recipientId is null!');
    }
  }

  Future<void> _pickFiles() async {
    print('📁 [_pickFiles] Opening file picker');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        onFileLoading: (FilePickerStatus status) {
          print('📁 [FilePicker] Status: $status');
        },
      );

      if (result != null) {
        print('📁 [_pickFiles] Selected ${result.files.length} file(s)');
        selectedFiles.addAll(result.files);
        print('📁 [_pickFiles] Total files: ${selectedFiles.length}');

        // Show selected files
        Get.snackbar(
          'Files Selected',
          '${result.files.length} file(s) selected. Tap send to upload.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else {
        print('📁 [_pickFiles] File picker cancelled');
      }
    } catch (e) {
      print('❌ [_pickFiles] Error: $e');
      Get.snackbar(
        'Error',
        'Failed to pick files: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _sendWithFiles() {
    print('📤 [_sendWithFiles] Sending with ${selectedFiles.length} file(s)');
    final filePaths = selectedFiles.map((file) => file.path!).toList();
    controller.sendMessage(filePaths: filePaths);
    selectedFiles.clear();
    print('📤 [_sendWithFiles] Selected files cleared');
  }

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
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
                ),
                Column(
                  spacing: 2,
                  children: [
                    Text(
                      "Al Majid Auto Service",
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.isConnected.value
                            ? "Active Now"
                            : "Connecting...",
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: controller.isConnected.value
                              ? Color(0xFF19B000)
                              : Colors.orange,
                        ),
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
                controller: controller.chatScrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isUser = message['isUser'] ?? false;
                  final text = message['text'] ?? message['content'] ?? '';
                  final files = message['files'] as List? ?? [];
                  if (files.isNotEmpty) {
                    // Debug attachments per message
                    // Avoid excessive logs by summarizing
                    // Print only first two URLs if many
                    final sample = files
                        .take(2)
                        .map((e) => e.toString())
                        .toList();
                    print(
                      '📎 [UI] Render attachments for message id=${message['id']} count=${files.length} sample=$sample',
                    );
                  }

                  // Message Row (with optional avatar)
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Profile image (only for receiver)
                          if (!isUser) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                Imagepath.profile,
                                height: 32,
                                width: 32,
                                fit: BoxFit.cover,
                              ),
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
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
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
                                  // Message Text (only if not just "Attachment")
                                  if (text.isNotEmpty && text != 'Attachment')
                                    Text(
                                      text,
                                      style: getTextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),

                                  // File previews (always show if present)
                                  if (files.isNotEmpty) ...[
                                    if (text.isNotEmpty && text != 'Attachment')
                                      const SizedBox(height: 8),
                                    ...files.map((e) => e.toString()).map((
                                      url,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: _attachmentRow(url),
                                      );
                                    }).toList(),
                                  ],

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
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Selected Files Preview
          Obx(
            () => selectedFiles.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected Files (${selectedFiles.length})',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: selectedFiles.map((file) {
                            return Chip(
                              label: Text(
                                file.name,
                                style: getTextStyle(fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              deleteIcon: const Icon(Icons.close, size: 16),
                              onDeleted: () {
                                selectedFiles.remove(file);
                                print(
                                  '📁 [Selected Files] Removed: ${file.name}',
                                );
                              },
                              backgroundColor: Colors.white,
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

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
                      // suffixIcon: GestureDetector(
                      //   onTap: _pickFiles,
                      //   child: const Icon(Icons.attach_file),
                      // ),
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
                Obx(
                  () => GestureDetector(
                    onTap: controller.isConnected.value
                        ? () {
                            if (selectedFiles.isNotEmpty) {
                              _sendWithFiles();
                            } else {
                              controller.sendMessage();
                            }
                          }
                        : null,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: controller.isConnected.value
                          ? Colors.blue
                          : Colors.grey,
                      child: controller.isConnected.value
                          ? const Icon(Icons.send, color: Colors.white)
                          : const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                    ),
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
