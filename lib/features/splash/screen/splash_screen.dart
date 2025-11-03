import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/features/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 300),
          Center(
            child: SizedBox(
              width: 350,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: controller.animationController,
                    child: Image.asset("assets/images/tire.png", width: 90),
                  ),

                  // tyre position 1 (your shown logo has only 1 wheel visually)
                  Positioned(
                    top: 42, // adjust this based on your PNG
                    child: Image.asset(
                      "assets/images/splash_car.jpg",
                      width: 350,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Image.asset("assets/images/sayara_hub.png", width: 200),
          const SizedBox(height: 10),
          Text('Find. Fix. Drive'),
          const Spacer(),

          /// 🔁 Rotating Image Section
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                // Move image slightly upward while fading out
                final slideUp =
                    Tween<Offset>(
                      begin: const Offset(0, 0.4), // start below
                      end: const Offset(0, -0.3), // go a bit above
                    ).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      ),
                    );

                final fade = Tween<double>(begin: -2.0, end: 2.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                );

                // Combine slide and fade
                return SlideTransition(
                  position: slideUp,
                  child: FadeTransition(opacity: fade, child: child),
                );
              },
              child: Image.asset(
                controller.images[controller.currentImageIndex.value],
                key: ValueKey(controller.currentImageIndex.value),
                width: 179,
                height: 60,
              ),
            );
          }),

          const SizedBox(height: 40),

          /// Bottom Button Section
          Container(
            height: 92,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.splashButtonColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Let's Go",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed('/onboardingScreen');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 16),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.splashButtonColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
