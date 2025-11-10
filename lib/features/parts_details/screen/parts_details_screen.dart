import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/widgets/custom_appbar.dart';
import 'package:yousef1234321/features/parts_details/controller/parts_details_controller.dart';
import 'package:yousef1234321/routes/app_route.dart';

class PartsDetailsScreen extends StatelessWidget {
  const PartsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PartsDetailsController());

    // 🔹 Reusable TextField
    Widget textField(String label, {String? hint}) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint ?? "Type here",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );

    // 🔹 Reusable Dropdown
    Widget dropdown(String label, List<String> items, RxString valueRx) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: valueRx.value.isEmpty ? null : valueRx.value,
                  isExpanded: true,
                  hint: const Text("Select"),
                  underline: const SizedBox(),
                  items: items
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) => valueRx.value = value ?? '',
                ),
              ),
            ),
          ],
        );

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
                Expanded(child: textField("Part Name *")),
                const SizedBox(width: 22.5),
                Expanded(
                  child: dropdown("Category *", [
                    "Brake Pads",
                    "Oil Filter",
                    "Battery",
                  ], c.category),
                ),
              ],
            ),
            const SizedBox(height: 30.5),
            Row(
              children: [
                Expanded(child: textField("Compatible Vehicles *")),
                const SizedBox(width: 12),
                Expanded(
                  child: dropdown("Condition *", ["New", "Used"], c.condition),
                ),
              ],
            ),
            const SizedBox(height: 22.5),
            Row(
              children: [
                Expanded(
                  child: dropdown("Brand *", [
                    "Toyota",
                    "Honda",
                    "Nissan",
                  ], c.brand),
                ),
                const SizedBox(width: 14),
                Expanded(child: textField("Part Number / Code *")),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              "2.Pricing & Availability",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: textField("Price [AED] *")),
                const SizedBox(width: 12),
                Expanded(
                  child: dropdown("Quantity Available *", [
                    "1",
                    "5",
                    "10",
                    "20",
                  ], c.quantity),
                ),
              ],
            ),
            const SizedBox(height: 20),

            textField("Description *", hint: "Type here..."),

            Row(
              children: [
                Expanded(
                  child: dropdown("Warranty Info *", [
                    "Yes",
                    "No",
                  ], c.warrantyInfo),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: dropdown("Delivery *", [
                    "Pickup",
                    "Delivery",
                  ], c.deliveryOption),
                ),
              ],
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
            textField("Seller Name *"),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: textField("Location *")),
                const SizedBox(width: 24),
                Expanded(child: textField("Contact Number *")),
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
            const Text(
              "Note: You can list up to 3 parts for free. After that, a small fee of 20 AED per part will apply.",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!c.isConfirmed.value) {
                    EasyLoading.showError(
                      "Error, Please confirm part information.",
                    );
                    return;
                  }
                  Get.toNamed(Approute.payment);
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
