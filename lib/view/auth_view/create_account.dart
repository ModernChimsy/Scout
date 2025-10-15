// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/step_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/sign_in_view.dart';
import 'package:restaurent_discount_app/view/auth_view/tell_us_about_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import '../../uitilies/custom_toast.dart';

class CreateAccountView extends StatelessWidget {
  CreateAccountView({super.key});

  final StepController stepController = Get.put(StepController());

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPassC = TextEditingController();

  static const String orangeLogoPath = "assets/icon/scout_logo_orange.svg";

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      Color textColor = isDarkMode ? Colors.white : Colors.black;
      Color subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isDarkMode
                      ? null
                      : LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [AppColors.scoutVividVermilion.withOpacity(0.1), Color(0xFFFFA07A).withOpacity(0.1)],
                        ),
                  color: isDarkMode ? AppColors.bgColor : Colors.transparent,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(decoration: BoxDecoration(gradient: isDarkMode ? null : AppColors.gradient)),
            ),
            // Foreground UI
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(orangeLogoPath, height: 30.h),

                      Obx(() {
                        return Row(
                          children: List.generate(3, (index) {
                            bool isActive = index < stepController.currentStep.value;
                            return Container(
                              margin: EdgeInsets.only(left: 6.w),
                              width: isActive ? 19.w : 10.w,
                              height: isActive ? 14.h : 10.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isActive ? AppColors.scoutVividVermilion : Colors.grey.shade300,
                              ),
                            );
                          }),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  CustomText(text: "Let’s begin", fontSize: 20.sp, fontWeight: FontWeight.bold, color: textColor),

                  SizedBox(height: 5.h),

                  // Subtitle
                  CustomText(text: "Create your login details below", fontSize: 14.sp, color: subtitleColor),

                  SizedBox(height: 30.h),

                  // Email Field
                  CustomText(text: "Email", fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: emailC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your email",
                    showObscure: false,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  SizedBox(height: 10.h),

                  // Password Field
                  CustomText(text: "Password", fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: passwordC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your password",
                    showObscure: true,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  SizedBox(height: 10.h),

                  // Confirm Password Field
                  CustomText(text: "Confirm Password", fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: confirmPassC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter confirm password",
                    showObscure: true,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  Spacer(),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: CustomButtonWidget(
                      bgColor: AppColors.btnColor,
                      btnText: "Create Account",
                      onTap: () {
                        String password = passwordC.text;
                        String confirmPassword = confirmPassC.text;

                        if (emailC.text.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                          CustomToast.showToast("Please fill out all fields", isError: true);
                        } else if (password != confirmPassword) {
                          CustomToast.showToast("Passwords do not match", isError: true);
                        } else {
                          stepController.nextStep();
                          Get.to(() => TellUsAboutYou(email: emailC.text, password: passwordC.text));
                        }
                      },
                      iconWant: false,
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Sign in text
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.poppins(fontSize: 14.sp, color: textColor),
                        children: [
                          TextSpan(
                            text: "Sign in",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(() => SignInView());
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
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
