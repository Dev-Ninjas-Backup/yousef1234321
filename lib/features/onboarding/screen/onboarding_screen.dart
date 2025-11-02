import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/imagepath.dart';
import 'package:yousef1234321/features/onboarding/controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    final List<Map<String, String>> onboardingData = [
      {
        'image': Imagepath.onboarding1,
        'title': 'Welcome To SayaraHub',
        'description':
            'Your one-stop platform to find garages, book mobile mechanics, and get emergency car services anywhere in the UAE.',
      },
      {
        'image': Imagepath.image2,
        'title': 'Find Trusted Garages',
        'description':
            'Search and filter garages by service type, vehicle model, ratings, and location for quick and reliable service.',
      },
      {
        'image': Imagepath.image3,
        'title': 'Car Repair at Your Doorstep',
        'description':
            'Schedule licensed mechanics for diagnostics, oil changes, battery replacements, and more all at home or office.',
      },
      {
        'image': Imagepath.onboarding1,
        'title': 'Stranded on the road? We’ve got you covered.',
        'description':
            'Get instant towing support anywhere, anytime. Just share your location and we’ll connect you with the nearest reliable towing service',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.splashButtonColor,
      body: Obx(() {
        int index = controller.currentIndex.value;
        return Column(
          children: [
            // Animated image section
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position:
                      Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeInOut,
                        ),
                      ),
                  child: child,
                );
              },
              child: Image.asset(
                onboardingData[index]['image']!,
                key: ValueKey(index),
              ),
            ),

            const SizedBox(height: 20),

            // Animated bottom section
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 600),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOut,
                          ),
                        ),
                    child: child,
                  );
                },
                child: SingleChildScrollView(
                  child: Container(
                    key: ValueKey(index),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 57,
                      bottom: 38,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          onboardingData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          onboardingData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (i) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 7,
                              width: i == index ? 45 : 13,
                              decoration: BoxDecoration(
                                color: i == index
                                    ? AppColors.splashButtonColor
                                    : const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 117),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (index > 0)
                              GestureDetector(
                                onTap: () {
                                  Get.offAllNamed('/signInScreen');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.splashButtonColor,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Skip',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (index > 0) const SizedBox(width: 16),
                            GestureDetector(
                              onTap: controller.nextPage,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: AppColors.splashButtonColor,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      index == 0 ? 'Get Started' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
