import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/widgets/custom_button.dart';
import 'package:yousef1234321/core/common/widgets/social_button.dart';
import 'package:yousef1234321/features/auth/sign_in/controller/sign_in_controller.dart';
import 'package:yousef1234321/routes/app_route.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Ensure controller exists and keep it permanent to avoid accidental disposal.
    if (!Get.isRegistered<SignInController>()) {
      Get.put(SignInController(), permanent: true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SignInController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, top: 24),
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.splashButtonColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Sign In Now',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please sign in to continue our app',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subTextColor,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Use widget-local controllers instead of controller.emailController
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email address",
                        prefixIcon: const Icon(Icons.email_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => TextField(
                        controller: _passwordController,
                        obscureText: !controller.isPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF7F7F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Approute.forgetPasswordScreen);
                        },
                        child: const Text(
                          "Forget Password?",
                          style: TextStyle(
                            color: AppColors.splashButtonColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      title: 'Sign In',
                      onPressed: () {
                        // Pass local controller values to avoid relying on possibly
                        // disposed controllers inside the SignInController.
                        controller.signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: AppColors.subTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          TextSpan(
                            text: "  Sign Up",
                            style: const TextStyle(
                              color: AppColors.splashButtonColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAllNamed('/signUpScreen');
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Or",
                      style: TextStyle(
                        color: AppColors.subTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SocialButton(
                      imagePath: Iconpath.google,
                      text: 'Continue with Google',
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),
                    SocialButton(
                      imagePath: Iconpath.apple,
                      text: 'Continue with Apple',
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
