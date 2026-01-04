import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:yousef1234321/routes/app_route.dart';
import '../../../../core/common/style/global_text_style.dart';
import '../../../../core/network/api_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void showDeletelDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phone Icon
            const Icon(Icons.warning_amber, color: Colors.red, size: 50),
            const SizedBox(height: 14),

            // Title
            Text(
              "delete_account_q".tr,
              style: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Text(
              "are_you_sure_delete_account".tr,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 2,
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: 15),
            ),
            const SizedBox(height: 12),
            Text(
              "delete_account_description".tr,
              // overflow: TextOverflow.ellipsis,
              // maxLines: 2,
              textAlign: TextAlign.center,
              style: getTextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Buttons
            Row(
              children: [
                // Cancel Button
                SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("cancel".tr, style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 16),

                // Delete Account Button
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Show loading and call delete endpoint
                        try {
                          EasyLoading.show(status: 'Deleting...');
                          final success = await ApiClient.to
                              .deleteUserAccount();
                          EasyLoading.dismiss();
                          if (success) {
                            // Close dialog if still open
                            if (Get.isDialogOpen == true) Get.back();
                          }
                        } catch (e) {
                          EasyLoading.dismiss();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            "delete_account".tr,
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
