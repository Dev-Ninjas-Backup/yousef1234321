import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yousef1234321/core/common/constants/app_colors.dart';
import 'package:yousef1234321/core/common/constants/iconpath.dart';
import 'package:yousef1234321/core/common/widgets/custom_button.dart';
import 'package:yousef1234321/core/common/widgets/social_button.dart';
import 'package:yousef1234321/features/auth/sign_up/controller/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
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
                    if (kDebugMode) {
                      print('Tapped');
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 24, top: 24),
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: Color(0xFFE8F1FD),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.splashButtonColor,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 47, right: 47),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Sign Up Now',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please fill the details and create account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.subTextColor,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: controller.nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Full Name",
                        prefixIcon: const Icon(Icons.person_outline),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email address",
                        prefixIcon: const Icon(Icons.email_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
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
                          fillColor: Color(0xFFF7F7F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: !controller.isConfirmPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed:
                                controller.toggleConfirmPasswordVisibility,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F7F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.garageNameController,
                      decoration: InputDecoration(
                        hintText: "Garage Name",
                        prefixIcon: const Icon(Icons.business),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.addressController,
                      decoration: InputDecoration(
                        hintText: "Address",
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.cityController,
                      decoration: InputDecoration(
                        hintText: "City",
                        prefixIcon: const Icon(Icons.location_city),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.emirateController,
                      decoration: InputDecoration(
                        hintText: "Emirate",
                        prefixIcon: const Icon(Icons.map_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      controller: controller.serviceCategoriesController,
                      decoration: InputDecoration(
                        hintText: "Service Categories",
                        prefixIcon: const Icon(Icons.category_outlined),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        filled: true,
                        fillColor: Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: controller.pickGarageLogo,
                      child: Obx(
                        () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.image_outlined),
                              SizedBox(width: 12),
                              Text(
                                controller.garageLogoFile.value?.path
                                        .split('/')
                                        .last ??
                                    "Garage Logo",
                                style: TextStyle(
                                  color: controller.garageLogoFile.value == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      onTap: controller.pickTradeLicense,
                      child: Obx(
                        () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.description_outlined),
                              SizedBox(width: 12),
                              Text(
                                controller.tradeLicenseFile.value?.path
                                        .split('/')
                                        .last ??
                                    "Trade License",
                                style: TextStyle(
                                  color:
                                      controller.tradeLicenseFile.value == null
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        initialValue: controller.selectedRole.value,
                        items: controller.roles
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedRole.value = value;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Role",
                          prefixIcon: const Icon(Icons.person_outline),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF7F7F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        "Password must be at least 8 characters",
                        style: TextStyle(
                          color: AppColors.subTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 63),
                    CustomButton(title: 'Sign Up', onPressed: () {}),
                    SizedBox(height: 48),
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
                            text: "  Sign In",
                            style: const TextStyle(
                              color: AppColors.splashButtonColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAllNamed('/signInScreen');
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Or",
                      style: TextStyle(
                        color: AppColors.subTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 15),

                    SocialButton(
                      imagePath: Iconpath.google,
                      text: 'Continue with Google',
                      onTap: () {},
                    ),
                    SizedBox(height: 24),
                    SocialButton(
                      imagePath: Iconpath.apple,
                      text: 'Continue with Apple',
                      onTap: () {},
                    ),
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
