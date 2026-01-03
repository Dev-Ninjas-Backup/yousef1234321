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
            hintText: hint ?? "Type here",
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
            CustomAppBar(title: "Create listing"),

            const SizedBox(height: 27),
            const Text(
              "Part Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: textField("Part Name *", controller: c.partNameCtrl),
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
                const Text(
                  'Listing Plan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),

                /// Monthly Subscription (Recommended)
                Obx(
                  () => _planTile(
                    title: 'Monthly Subscription - 100 AED',
                    subtitle:
                        'Unlimited spare parts listings for 30 days. Best value for sellers with multiple parts.',
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
                    title: 'Pay Per Listing',
                    subtitle:
                        'No subscription required. Use auto-renewal option below.',
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
                          "Monthly Active until ${c.productMonthlyEndsAt.value?.toLocal().toString().split(' ').first}",
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
                        child: const Text("Pay Now (Monthly)"),
                      ),
                    );
                  }

                  /// PAY PER LISTING (ONLY WHEN NO MONTHLY)
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (c.productCredits.value > 0) {
                          EasyLoading.showSuccess(
                            "Using available product credit",
                          );
                          return;
                        }
                        await c.createPayPerListingPayment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Pay Now (Per Listing)"),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 22.5),

            PromoteListingView(),
            const SizedBox(height: 22.5),

            textField("Brand *", hint: "Type here...", controller: c.brand),

            const SizedBox(height: 24),
            const Text(
              "2.Pricing & Availability",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: textField("Price [AED] *", controller: c.priceCtrl),
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
              "Quantity *",
              hint: "Type here...",
              controller: c.quantity,
            ),
            const SizedBox(height: 20),

            textField(
              "Description *",
              hint: "Type here...",
              controller: c.descriptionCtrl,
            ),

            const SizedBox(height: 20),
            const Text(
              "Upload Photo *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Obx(
              () => GestureDetector(
                onTap: c.pickImage,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: c.selectedImage.value == null
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 4),
                              Text("Add Photo"),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(c.selectedImage.value!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Seller Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            textField("Seller Name *", controller: c.sellerNameCtrl),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: textField("Email *", controller: c.emailCtrl)),
                const SizedBox(width: 24),
                Expanded(
                  child: textField("Contact Number *", controller: c.phoneCtrl),
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
                    "I confirm this part information is accurate.",
                    style: TextStyle(fontSize: 14),
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
                    EasyLoading.showError(
                      "Error, Please confirm part information.",
                    );
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
                child: const Text(
                  "List Part Now",
                  style: TextStyle(
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
                        child: const Text(
                          'Recommended',
                          style: TextStyle(fontSize: 11, color: Colors.white),
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
        const Text(
          "Category *",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
            hint: const Text("Select"),
            underline: const SizedBox(),
            items: c.categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat.id, // store id
                child: Text(cat.name), // show name
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
