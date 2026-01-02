// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yousef1234321/features/brake_pads/controller/brake_pads_controller.dart';

class BrakePadsScreen extends StatelessWidget {
  BrakePadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(BrakePadsController());

    Widget badge(String text, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                    Text(
                      "brake_pads".tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 12),
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
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
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/image2.png',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              );
                            }
                            if (img.isNotEmpty) {
                              return Image.asset(
                                img,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            }
                            return Image.asset(
                              'assets/images/image2.png',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                    ),

                    // Discount Tag
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "discount_tag".tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${c.selectedImageIndex.value + 1}/${c.images.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final selected = c.selectedImageIndex.value == i;
                      final img = c.images[i].toString();
                      final ImageProvider provider = img.startsWith('http')
                          ? NetworkImage(img)
                          : AssetImage(img) as ImageProvider;
                      return GestureDetector(
                        onTap: () => c.changeImage(i),
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selected
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
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

                const SizedBox(height: 25),
                // product info
                Text(
                  c.product['partName']?.toString() ?? "brake_pads".tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  c.product['brand']?.toString() ?? '',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 14, 14, 14),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    badge("in_stock".tr, Colors.green),
                    const SizedBox(width: 8),
                    badge("oem_quality".tr, Colors.blue),
                    const Spacer(),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                        Text(
                          c.product['rating']?.toString() ?? '(0.0)',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 8),
                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${c.product['price']?.toString() ?? '0'}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 7),
                    if (c.product['promoCost'] != null)
                      Text(
                        '\$${c.product['promoCost'].toString()}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "condition".tr,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.product['condition']?.toString() ?? "na".tr,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
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
                            _showConfirmCallDialog(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        _contactButton(
                          Icons.chat_bubble_outline,
                          Colors.blue,
                          onTap: () {
                            EasyLoading.showInfo("opening_chat".tr);
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Text(
                  "key_features".tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FeatureItem(
                      c.product['description']?.toString() ??
                          "no_description".tr,
                    ),
                  ],
                ),

                const SizedBox(height: 40),
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
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  static void _showConfirmCallDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF00C853),
                    child: Icon(Icons.call, color: Colors.white, size: 30),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 24,
                  child: Text(
                    "confirm_call".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "call_confirmation_msg".tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromARGB(137, 18, 17, 17),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => Get.back(),
                      child: SizedBox(
                        child: Text(
                          "cancel".tr,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        EasyLoading.showSuccess("calling_msg".tr);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(Icons.phone, size: 19.5),
                      label: Text("call_now".tr),
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
}

class _FeatureItem extends StatelessWidget {
  final String text;
  const _FeatureItem(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    ),
  );
}
