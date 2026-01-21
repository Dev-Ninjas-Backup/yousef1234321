import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yousef1234321/features/service/service_booking/controller/service_booking_controller.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/call_dialog.dart';
import 'package:yousef1234321/features/service/service_booking/widgets/service_message.dart';
import 'package:yousef1234321/core/common/widgets/translated_text.dart';
import '../../../../core/common/constants/app_colors.dart';
import '../../../../core/common/constants/iconpath.dart';
import '../../../../core/common/style/global_text_style.dart';

class ServiceBookingMiddleSection extends StatelessWidget {
  final ServiceBookingController controller;

  const ServiceBookingMiddleSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final garage = controller.garageDetail.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    text: garage?.name ?? "loading",
                    style: getTextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        "${garage?.averageRating.toStringAsFixed(1) ?? '0.0'} (${garage?.totalReviews ?? 0})",
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.subTextColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      TranslatedText(
                        text: "• ${garage?.city ?? ''}",
                        style: getTextStyle(
                          fontSize: 12,
                          color: AppColors.subTextColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 8, color: Colors.green),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (garage != null && garage.services.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      children: [
                        if (garage.brandExpertise.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: .1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TranslatedText(
                              text: garage.brandExpertise.first,
                              style: getTextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        Text(
                          garage.services
                              .take(3)
                              .map((s) => controller.mapServiceToKey(s).tr)
                              .join(" • "),
                          style: getTextStyle(
                            fontSize: 16,
                            color: AppColors.subTextColor,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Use garagePhone first, then fallback to user phone
                    final phoneNumber = garage?.garagePhone ?? garage?.user?.phone;
                    print('📞 [Call Button] Phone number: $phoneNumber');
                    
                    if (phoneNumber != null && phoneNumber.isNotEmpty) {
                      showCallDialog(
                        garageName: garage?.name,
                        phoneNumber: phoneNumber,
                      );
                    } else {
                      Get.snackbar(
                        'Error',
                        'Phone number not available',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Image.asset(Iconpath.callIcon, height: 36, width: 36),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    // Debug the garage detail structure
                    print('🔍 [Debug] Full garage detail: ${controller.garageDetail.value}');
                    print('🔍 [Debug] Garage user: ${controller.garageDetail.value?.user}');
                    print('🔍 [Debug] Garage userId field: ${controller.garageDetail.value?.userId}');
                    
                    // Try multiple ways to get the owner ID
                    String? garageOwnerId = controller.garageDetail.value?.user?.id;
                    
                    // Fallback to userId field if user.id is not available
                    if (garageOwnerId == null || garageOwnerId.isEmpty) {
                      garageOwnerId = controller.garageDetail.value?.userId;
                      print('🔄 [Message Button] Using userId fallback: $garageOwnerId');
                    }
                    
                    final garageName = controller.garageDetail.value?.user!.fullName;
                    print(
                      '📨 [Message Button] Navigating to ServiceMessage with garageOwnerId: $garageOwnerId',
                    );

                    if (garageOwnerId != null && garageOwnerId.isNotEmpty) {
                      Get.to(
                        ServiceMessage(
                          recipientId: garageOwnerId,
                          garageName: garageName,
                        ),
                      );
                    } else {
                      print('❌ [Message Button] Garage owner ID not available');
                      print('❌ [Message Button] Available data: user=${controller.garageDetail.value?.user}, userId=${controller.garageDetail.value?.userId}');
                      Get.snackbar(
                        'Error',
                        'Unable to open chat - garage owner information not loaded',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Image.asset(
                    Iconpath.messageIcon,
                    height: 36,
                    width: 36,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        // Location button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          ),
          onPressed: () async {
            final g = controller.garageDetail.value;
            if (g == null) return;
            final lat = g.garageLat;
            final lng = g.garageLng;
            if (lat == 0 || lng == 0) {
              EasyLoading.showError('location_not_available'.tr);
              return;
            }

            final uri = Uri.parse(
              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
            );
            try {
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                EasyLoading.showError('could_not_open_maps'.tr);
              }
            } catch (e) {
              EasyLoading.showError('could_not_open_maps'.tr);
            }
          },
          icon: const Icon(
            Icons.location_on_outlined,
            size: 18,
            color: Colors.white,
          ),
          label: TranslatedText(
            text: "see_location",
            style: getTextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Garage Overview
        TranslatedText(
          text: "garage_overview",
          style: getTextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        const SizedBox(height: 14),
        TranslatedText(
          text: garage?.description ?? "default_garage_description",
          style: getTextStyle(color: AppColors.subTextColor, fontSize: 12),
        ),

        // Show certifications if available
        if (garage != null && garage.certifications.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: garage.certifications.map((cert) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withValues(alpha: .3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      cert,
                      style: getTextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
