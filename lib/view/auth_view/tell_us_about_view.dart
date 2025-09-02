// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/step_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/share_interest_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import '../../uitilies/custom_toast.dart';

class TellUsAboutYou extends StatelessWidget {
  final String email;
  final String password;

  TellUsAboutYou({super.key, required this.email, required this.password});

  final StepController stepController = Get.put(StepController());

  final TextEditingController fullNameC = TextEditingController();
  final TextEditingController userNameC = TextEditingController();

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
                  color: isDarkMode
                      ? AppColors.bgColor
                      : Colors.transparent, // Dark background color
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

                      // Step Indicator using Obx
                      Obx(() {
                        return Row(
                          children: List.generate(3, (index) {
                            bool isActive =
                                index < stepController.currentStep.value;
                            return Container(
                              margin: EdgeInsets.only(left: 6.w),
                              width:
                                  isActive ? 19.w : 10.w, // Larger active step
                              height: isActive ? 10.h : 10.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: isActive
                                    ? AppColors.btnColor
                                    : Colors.grey.shade300,
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Welcome Text
                  CustomText(
                    text: "Tell us about you",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),

                  SizedBox(height: 5.h),

                  // Subtitle
                  CustomText(
                    text: "Let’s create your profile",
                    fontSize: 14.sp,
                    color: isDarkMode ? Colors.white : Colors.black54,
                  ),

                  SizedBox(height: 30.h),

                  // Full Name Field
                  CustomText(
                      text: "Full Name",
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: fullNameC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your full name",
                    showObscure: false,
                  ),

                  SizedBox(height: 10.h),

                  // Username Field
                  CustomText(
                    text: "Username*",
                    fontSize: 14.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: userNameC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your username",
                    showObscure: false,
                  ),

                  SizedBox(height: 10.h),

                  CustomText(
                    textAlign: TextAlign.start,
                    text:
                        "*Your username is what your friends will use to find your public profile.",
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),

                  Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: CustomButtonWidget(
                      bgColor: AppColors.btnColor,
                      btnText: "Next",
                      onTap: () {
                        String fullName = fullNameC.text;
                        String userName = userNameC.text;

                        if (fullName.isEmpty || userName.isEmpty) {
                          CustomToast.showToast(
                            "Please fill out all fields",
                            isError: true,
                          );
                        } else {
                          // Proceed to the next screen
                          stepController.nextStep();
                          Get.to(() => ShareInterestView(
                                fullName: fullName,
                                userName: userName,
                                email: email,
                                password: password,
                              ));
                        }
                      },
                      iconWant: false,
                    ),
                  ),

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
