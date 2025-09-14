// lib/view/splash view/welcome_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/auth_view/create_account.dart';
import 'package:restaurent_discount_app/view/auth_view/sign_in_view.dart';
import 'dart:ui';
import '../../common widget/custom text/custom_text_widget.dart';
// ❗️ FIX: Import the new controller
import 'controller/welcome_controller.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // ❗️ FIX: Initialize the controller for state management
    final WelcomeController controller = Get.put(WelcomeController());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg.png', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 150),
                Image.asset('assets/images/white_logo.png', height: 80),
                const Spacer(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: 405,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        text: 'Welcome to Scout',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      CustomText(
                        text:
                        'Discover and share the best local events with your friends',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 20),
                      // ❗️ FIX: Updated Google Sign-in Button with loading state
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                            controller.handleGoogleSignIn();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(
                            color: AppColors.btnColor,
                          )
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/g.png",
                                  width: 25),
                              const SizedBox(width: 10),
                              const Text(
                                'Continue With Google',
                                style: TextStyle(
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )),
                      ),
                      const SizedBox(height: 10),

                      CustomText(
                        text: "Or",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: 300,
                          height: 50,
                          child: CustomButtonWidget(
                              bgColor: AppColors.btnColor,
                              btnText: "Register",
                              onTap: () {
                                Get.to(() => CreateAccountView());
                              },
                              iconWant: false)),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: 300,
                          height: 50,
                          child: CustomButtonWidget(
                              bgColor: Colors.white,
                              btnText: "Sign in",
                              btnTextColor: AppColors.btnColor,
                              onTap: () {
                                Get.to(() => SignInView());
                              },
                              iconWant: false)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
