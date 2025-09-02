// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/auth_view/create_account.dart';
import 'package:restaurent_discount_app/view/auth_view/sign_in_view.dart';
import 'dart:ui';

import '../../common widget/custom text/custom_text_widget.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: 150),
                Image.asset(
                  'assets/images/white_logo.png',
                  height: 80,
                ),
                Spacer(),
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
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
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
                      SizedBox(height: 10),
                      CustomText(
                        text:
                            'Discover and share the best local events with your friends',
                        textAlign: TextAlign.center,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(height: 20),

                      // Google Sign-in Button
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.white, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage("assets/images/g.png"),
                                width: 25,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Continue With Google',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      CustomText(
                        text: "Or",
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(height: 10),

                      // Register Button
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
                      SizedBox(height: 8),

                      // Sign In Button
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
