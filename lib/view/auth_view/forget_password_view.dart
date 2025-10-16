// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/forget_password_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/otp_cofirmation_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class ForgetPasswordView extends StatelessWidget {
  ForgetPasswordView({super.key});

  final ForgetPasswordController _forgetPasswordController = Get.put(ForgetPasswordController());
  final TextEditingController _emailC = TextEditingController();

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

                  // Logo and Progress Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [SvgPicture.asset(orangeLogoPath, height: 20.h)],
                  ),

                  SizedBox(height: 30.h),

                  // Welcome Text
                  CustomText(text: "Forgot Password", fontSize: 20.sp, fontWeight: FontWeight.bold, color: textColor),

                  SizedBox(height: 5.h),

                  // Subtitle
                  CustomText(
                    textAlign: TextAlign.start,
                    text: "Enter the email address used to create your account.",
                    fontSize: 14.sp,
                    color: subtitleColor,
                  ),

                  SizedBox(height: 20.h),

                  // Email Field
                  CustomText(text: "Email", fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: _emailC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your email",
                    showObscure: false,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  SizedBox(height: 10.h),

                  Spacer(),

                  Obx(() {
                    return _forgetPasswordController.isLoading.value == true
                        ? CustomLoader()
                        : SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: CustomButtonWidget(
                              bgColor: AppColors.btnColor,
                              btnText: "Send Email",
                              onTap: () {
                                if (_emailC.text.isEmpty) {
                                  CustomToast.showToast("Please enter your valid email", isError: true);
                                } else {
                                  _forgetPasswordController.forgetPass(email: _emailC.text);
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
