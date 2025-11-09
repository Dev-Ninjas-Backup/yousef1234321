
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:yousef1234321/features/brake_pads/controller/brake_pads_controller.dart';

class BrakePadsScreen extends StatelessWidget {
  const BrakePadsScreen({super.key});

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
                // 🔹 Top Bar
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
                    const Text(
                      "Brake Pads",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),

                const SizedBox(height: 12),

                // 🔹 Main Image with discount + counter
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          c.images[c.selectedImageIndex.value],
                          fit: BoxFit.cover,
                          width: double.infinity,
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
                        child: const Text(
                          "-15%",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    // 🔹 Counter (1/4)
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

                // 🔹 Thumbnail list
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: c.images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final selected = c.selectedImageIndex.value == i;
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
                              image: AssetImage(c.images[i]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // 🔹 Stock & Rating
                Row(
                  children: [
                    badge("In Stock", Colors.green),
                    const SizedBox(width: 8),
                    badge("OEM Quality", Colors.blue),
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
                        const Text(
                          "(4.8)",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text(
                  "Premium Ceramic Brake Pads Set",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Compatible with Honda Civic 2016–2022",
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 14, 14),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "\$89.99",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 7),
                    Text(
                      "\$106.99",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 7),
                    Text("Save \$16", style: TextStyle(color: Colors.green)),
                  ],
                ),

                const SizedBox(height: 30),

                // 🔹 Vehicle Compatibility
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vehicle Compatibility",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Honda Civic 2016–2022",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
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
                            EasyLoading.showInfo("Opening chat window...");
                          },
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Key Features",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FeatureItem("Low noise ceramic formula"),
                    _FeatureItem("Extended pad life"),
                    _FeatureItem("Superior stopping power"),
                    _FeatureItem("2-year warranty included"),
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

  // 🔹 Contact Button
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

  // 🔹 Confirm Call Dialog (Figma Style)
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
                  child: const Text(
                    "Confirm Call?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You're about to call Al Majid Auto Service",
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.back();
                        EasyLoading.showSuccess(
                          "Calling Al Majid Auto Service...",
                        );
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
                      label: const Text("Call Now"),
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
  const _FeatureItem(this.text, {super.key});

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
