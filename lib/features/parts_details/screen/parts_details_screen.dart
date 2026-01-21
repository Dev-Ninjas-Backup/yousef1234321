import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/parts_details/controller/parts_details_controller.dart';
import 'package:yousef1234321/features/parts_details/widgets/promotion_listing.dart';

class PartsDetailsScreen extends StatelessWidget {
  const PartsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PartsDetailsController());

    // 🔹 Reusable TextField
    Widget textField(
      String label, {
      required TextEditingController controller,
      String? hint,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint ?? "type_here".tr,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );

    // 🔹 Reusable Dropdown

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor:  Colors.white,
      //   leading: IconButton(
      //     onPressed: () => Get.back(),
      //     icon: const Icon(Icons.arrow_back_ios_new_rounded),
      //   ),
      //   title: const Text('Create Listing'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(title: "create_listing".tr),

            const SizedBox(height: 27),
            Text(
              "part_information".tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: textField(
                    "${'part_name'.tr} *",
                    controller: c.partNameCtrl,
                  ),
                ),
                const SizedBox(width: 22.5),
                // Expanded(
                //   child: dropdown("Category *", [
                //     "Brake Pads",
                //     "Oil Filter",
                //     "Battery",
                //   ], c.categories),
                // ),
                Expanded(child: categoryDropdown(c)),
              ],
            ),
            const SizedBox(height: 30.5),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'listing_plan'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                /// Monthly Subscription (Recommended)
                Obx(
                  () => _planTile(
                    title: 'monthly_subscription_title'.tr,
                    subtitle: 'monthly_subscription_desc'.tr,
                    value: 0,
                    isRecommended: true,
                    selectedValue: c.selectedPlan.value,
                    onTap: () => c.selectPlan(0),
                  ),
                ),

                const SizedBox(height: 12),

                /// Pay Per Listing
                Obx(
                  () => _planTile(
                    title: 'pay_per_listing'.tr,
                    subtitle: 'pay_per_listing_desc'.tr,
                    value: 1,
                    isRecommended: false,
                    selectedValue: c.selectedPlan.value,
                    onTap: () => c.selectPlan(1),
                  ),
                ),

                SizedBox(height: 20),

                Obx(() {
                  /// MONTHLY ACTIVE → SHOW ONLY STATUS
                  if (c.hasProductMonthly.value) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "monthly_active_until".trParams({
                            'date':
                                c.productMonthlyEndsAt.value
                                    ?.toLocal()
                                    .toString()
                                    .split(' ')
                                    .first ??
                                '',
                          }),
                        ),
                      ),
                    );
                  }

                  /// ❌ MONTHLY NOT ACTIVE
                  /// MONTHLY SELECTED
                  if (c.selectedPlan.value == 0) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await c.createMonthlyPayment();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("pay_now_monthly".tr),
                      ),
                    );
                  }

                  /// PAY PER LISTING (ONLY WHEN NO MONTHLY)
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (c.productCredits.value > 0) {
                          EasyLoading.showSuccess("using_credit".tr);
                          return;
                        }
                        await c.createPayPerListingPayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("pay_now_per_listing".tr),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 22.5),

            PromoteListingView(),
            const SizedBox(height: 22.5),

            textField(
              "${'brand'.tr} *",
              hint: "type_here".tr,
              controller: c.brand,
            ),

            const SizedBox(height: 24),
            Text(
              "pricing_availability".tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: textField(
                    "${'price_aed'.tr} *",
                    controller: c.priceCtrl,
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: dropdown("Quantity Available *", [
                //     "1",
                //     "5",
                //     "10",
                //     "20",
                //   ], c.quantity),
                // ),
              ],
            ),
            SizedBox(height: 24),
            textField(
              "${'quantity'.tr} *",
              hint: "type_here".tr,
              controller: c.quantity,
            ),
            const SizedBox(height: 20),

            textField(
              "${'description'.tr} *",
              hint: "type_here".tr,
              controller: c.descriptionCtrl,
            ),

            const SizedBox(height: 20),
            Text(
              "${'upload_photo'.tr} *",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Obx(
              () => GestureDetector(
                onTap: c.pickImages, // select more images
                child: Container(
                  height: 140,
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: c.selectedImages.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                                size: 36,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "add_photos".tr,
                              ), // This needs to be const removed if using .tr, but Text("...".tr) is not const
                            ],
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              c.selectedImages.length + 1, // +1 for add button
                          itemBuilder: (_, index) {
                            if (index == c.selectedImages.length) {
                              // Last item = add more button
                              return GestureDetector(
                                onTap: c.pickImages,
                                child: Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final img = c.selectedImages[index];
                            return Stack(
                              children: [
                                Container(
                                  width: 120,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(img.path),
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () => c.removeImage(index),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              "seller_information".tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            textField("${'seller_name'.tr} *", controller: c.sellerNameCtrl),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: textField(
                    "${'emailAddress'.tr} *",
                    controller: c.emailCtrl,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: textField(
                    "${'contact_number'.tr} *",
                    controller: c.phoneCtrl,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Checkbox(
                    value: c.isConfirmed.value,
                    onChanged: (v) => c.isConfirmed.value = v ?? false,
                  ),
                ),
                SizedBox(height: 28),
                Expanded(
                  child: Text(
                    "confirm_info_accurate".tr,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // const Text(
            //   "Note: You can list up to 3 parts for free. After that, a small fee of 20 AED per part will apply.",
            //   style: TextStyle(color: Colors.red, fontSize: 12),
            // ),

            //     const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!c.isConfirmed.value) {
                    EasyLoading.showError("error_confirm_info".tr);
                    return;
                  }

                  // 🔥 PROMOTION CHECK
                  final canProceed = await c.validatePromotionBeforeSubmit();
                  if (!canProceed) return;

                  // 🔥 CREATE PRODUCT
                  await c.createProduct();

                  // if (!c.isConfirmed.value) {
                  //   EasyLoading.showError(
                  //     "Error, Please confirm part information.",
                  //   );
                  //   return;
                  // }

                  //hit create product api
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "list_part_now".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

Widget _planTile({
  required String title,
  required String subtitle,
  required int value,
  required int selectedValue,
  required VoidCallback onTap,
  required bool isRecommended,
}) {
  final bool isSelected = value == selectedValue;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withValues(alpha: 0.08) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<int>(
            value: value,
            groupValue: selectedValue,
            onChanged: (_) => onTap(),
            activeColor: Colors.blue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isRecommended)
                      Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'recommended'.tr,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Flexible(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget categoryDropdown(PartsDetailsController c) {
  return Obx(() {
    if (c.isLoadingCategories.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (c.errorMessageCategories.isNotEmpty) {
      return Text(
        c.errorMessageCategories.value,
        style: const TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${'category'.tr} *",
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: c.selectedCategoryId.value,
            isExpanded: true,
            hint: Text("select".tr),
            underline: const SizedBox(),
            items: c.categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat.id, // store id
                child: Text(cat.name.tr), // show name
              );
            }).toList(),
            onChanged: (value) {
              c.selectedCategoryId.value = value;
            },
          ),
        ),
      ],
    );
  });
}
