// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yousef1234321/features/brake_pads/controller/brake_pads_controller.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/service_message.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/service/translation_service.dart';

class BrakePadsScreen extends StatelessWidget {
  const BrakePadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BrakePadsController());

    Widget badge(String text, Color color) => Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: TranslatedText(
        text: text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(Iconpath.arrowback, height: 44, width: 44),
                    ),
                    Expanded(
                      child: TranslatedText(
                        text: "brake_pads",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),

                SizedBox(height: 12.h),
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Builder(
                          builder: (_) {
                            final img =
                                (c.images.isNotEmpty &&
                                    c.selectedImageIndex.value <
                                        c.images.length)
                                ? c.images[c.selectedImageIndex.value]
                                : '';
                            if (img.toString().startsWith('http')) {
                              return Image.network(
                                img,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              );
                            }
                            if (img.isNotEmpty) {
                              return Image.asset(
                                img,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[200],
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 48.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              );
                            }
                            return Container(
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.image_outlined,
                                size: 48.sp,
                                color: Colors.grey[500],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Discount Tag
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: TranslatedText(
                          text: "discount_tag",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${c.selectedImageIndex.value + 1}/${c.images.length}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),
                SizedBox(
                  height: 70.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.images.length,
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemBuilder: (_, i) {
                      final selected = c.selectedImageIndex.value == i;
                      final img = c.images[i].toString();
                      final ImageProvider provider = img.startsWith('http')
                          ? NetworkImage(img)
                          : AssetImage(img) as ImageProvider;
                      return GestureDetector(
                        onTap: () => c.changeImage(i),
                        child: Container(
                          width: 70.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 2.w,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                            image: DecorationImage(
                              image: provider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 1),
                Row(
                  children: [
                    badge("in_stock", Colors.green),
                    SizedBox(width: 8.w),
                    badge("oem_quality", Colors.blue),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.amber, size: 18.sp),
                    SizedBox(width: 4.w),
                    Text(
                      c.product['rating']?.toString() ?? '(0.0)',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // product info
                TranslatedText(
                  text: c.product['partName']?.toString() ?? "brake_pads",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                TranslatedText(
                  text: c.product['brand']?.toString() ?? '',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 14, 14, 14),
                    fontSize: 14.sp,
                  ),
                ),

                SizedBox(height: 20.h),

                SizedBox(height: 8.h),
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${c.product['price']?.toString() ?? '0'} AED',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 7.w),
                    if (c.product['promoCost'] != null)
                      Text(
                        '${c.product['promoCost'].toString()} AED',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                  ],
                ),

                SizedBox(height: 30.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslatedText(
                            text: "Vehicle Compatibility",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TranslatedText(
                            text:
                                c.product['Vehicle Compatibility']
                                    ?.toString() ??
                                "Honda Clvic 2016-2022",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _contactButton(
                          Icons.call,
                          Colors.blue,
                          onTap: () {
                            final phoneNumber =
                                c.product['seller']?['phoneNumber']
                                    ?.toString() ??
                                '';
                            final sellerName =
                                c.product['seller']?['name']?.toString() ??
                                'Seller';
                            _showConfirmCallDialog(
                              context,
                              sellerName,
                              phoneNumber,
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        _contactButton(
                          Icons.chat_bubble_outline,
                          Colors.blue,
                          onTap: () async {
                            // Use createdById (actual user) instead of sellerId
                            final userId = c.product['createdById'];
                            final sellerName =
                                c.product['createdBy']?['fullName'];

                            print('\n\n');
                            print('═══════════════════════════════════════');
                            print('🟦 [BrakePadsScreen] CHAT BUTTON TAPPED');
                            print('═══════════════════════════════════════');
                            print('userId (createdById): $userId');
                            print('userId type: ${userId.runtimeType}');
                            print('userId is not null: ${userId != null}');
                            print('userId is not empty: ${userId?.isNotEmpty}');
                            print('sellerName: $sellerName');
                            print('sellerName type: ${sellerName.runtimeType}');
                            print(
                              'product data keys: ${(c.product as Map).keys.toList()}',
                            );
                            print('═══════════════════════════════════════\n');

                            if (userId != null && userId.isNotEmpty) {
                              print(
                                '✅ [BrakePadsScreen] User data valid, navigating to ServiceMessage',
                              );
                              Get.to(
                                ServiceMessage(
                                  recipientId: userId,
                                  garageName: sellerName,
                                ),
                              );
                            } else {
                              print(
                                '❌ [BrakePadsScreen] User data missing! userId=$userId',
                              );
                              EasyLoading.showError(
                                await Get.find<TranslationService>().translate(
                                  Get.translations['en_US']?['seller_info_unavailable'] ??
                                      'Seller info unavailable',
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 30.h),

                TranslatedText(
                  text: "key_features",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureItem(
                      c.product['description']?.toString() ?? "no_description",
                    ),
                  ],
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _contactButton(
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(icon, color: color, size: 22.sp),
      ),
    );
  }

  static void _showConfirmCallDialog(
    BuildContext context,
    String sellerName,
    String phoneNumber,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12.r,
                  offset: Offset(0, 6.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: CircleAvatar(
                    radius: 28.r,
                    backgroundColor: const Color(0xFF00C853),
                    child: Icon(Icons.call, color: Colors.white, size: 30.sp),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 24.h,
                  child: TranslatedText(
                    text: "confirm_call",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                TranslatedText(
                  text:
                      (Get.translations['en_US']?['call_confirmation_msg'] ??
                              "You're about to call @garageName")
                          .replaceAll('@garageName', sellerName)
                          .replaceAll('@phoneNumber', phoneNumber),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(137, 18, 17, 17),
                    fontSize: 14.sp,
                  ),
                ),
                if (phoneNumber.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(height: 12.h),
                      Text(
                        phoneNumber,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 22.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: SizedBox(
                        child: TranslatedText(
                          text: "cancel",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: phoneNumber.isEmpty
                          ? null
                          : () async {
                              Get.back();
                              _makePhoneCall(phoneNumber);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 10.h,
                        ),
                      ),
                      icon: Icon(Icons.phone, size: 19.5.sp),
                      label: TranslatedText(text: "call_now"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        EasyLoading.showError(
          await Get.find<TranslationService>().translate(
            Get.translations['en_US']?['unable_to_call'] ?? 'Unable to call',
          ),
        );
      }
    } catch (e) {
      EasyLoading.showError(
        await Get.find<TranslationService>().translate(
          Get.translations['en_US']?['error_calling'] ?? 'Error calling',
        ),
      );
    }
  }
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.green, size: 18.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: TranslatedText(
            text: text,
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
