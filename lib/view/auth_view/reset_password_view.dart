// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/reset_password_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/sign_in_view.dart';
import 'package:restaurent_discount_app/view/auth_view/tell_us_about_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import '../../uitilies/custom_toast.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ResetPasswordController _resetPasswordController =
      Get.put(ResetPasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        body: Stack(
          children: [
            // Gradient Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? null
                      : LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xFFFB6012).withOpacity(0.1),
                            Color(0xFFFFA07A).withOpacity(0.1),
                          ],
                        ),
                  color: isDarkMode ? AppColors.bgColor : Colors.transparent,
                ),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? null
                      : LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white,
                          ],
                        ),
                ),
              ),
            ),

            // Foreground UI
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),

                  // Logo and Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(image: AssetImage("assets/images/long_logo.png")),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Welcome Text
                  CustomText(
                    text: "Create a new password",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),

                  SizedBox(height: 5.h),

                  // Subtitle
                  CustomText(
                    textAlign: TextAlign.start,
                    text: "This will be your new password for",
                    fontSize: 14.sp,
                    color: isDarkMode ? Colors.white : Colors.black54,
                  ),

                  SizedBox(height: 20.h),

                  // Password Field
                  CustomText(
                    text: "Password",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: passwordController,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your password",
                    showObscure: true,
                  ),

                  SizedBox(height: 10.h),

                  // Confirm Password Field
                  CustomText(
                    text: "Confirm Password",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: confirmPasswordController,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your confirm password",
                    showObscure: true,
                  ),

                  Spacer(),

                  // Next Button

                  Obx(() {
                    return _resetPasswordController.isLoading.value == true
                        ? CustomLoader()
                        : SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: CustomButtonWidget(
                              bgColor: AppColors.btnColor,
                              btnText: "Reset Password",
                              onTap: () {
                                String password = passwordController.text;
                                String confirmPassword =
                                    confirmPasswordController.text;

                                if (password.isEmpty ||
                                    confirmPassword.isEmpty) {
                                  CustomToast.showToast(
                                    "Please fill out both fields",
                                    isError: true,
                                  );
                                } else if (password != confirmPassword) {
                                  CustomToast.showToast(
                                    "Passwords do not match",
                                    isError: true,
                                  );
                                } else {
                                  _resetPasswordController.resetPassword(
                                      newPass: password);
                                }
                              },
                              iconWant: false,
                            ),
                          );
                  }),

                  SizedBox(height: 10.h),

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
