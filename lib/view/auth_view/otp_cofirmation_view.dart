// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/otp_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/widget/otp_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class OTPConfirmationView extends StatelessWidget {
  final bool redirectFromView;
  final String email;
  OTPConfirmationView({super.key, required this.redirectFromView, required this.email});

  final TextEditingController otpFormC = TextEditingController();

  final OTPController _otpController = Get.put(OTPController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image(image: AssetImage("assets/images/long_logo.png")),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Welcome Text
                  CustomText(
                    text: "Check your email",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),

                  SizedBox(height: 5.h),

                  // Subtitle
                  CustomText(
                    textAlign: TextAlign.start,
                    text:
                        "We’ve sent a otp $email to reset your password.",
                    fontSize: 14.sp,
                    color: isDarkMode ? Colors.white : Colors.black54,
                  ),

                  SizedBox(height: 20.h),

                  OtpForm(controller: otpFormC),
                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Didn’t receive OTP",
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      CustomText(
                        text: "Resend Code",
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  Spacer(),

                  Obx(() {
                    return _otpController.isLoading.value == true
                        ? CustomLoader()
                        : SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: CustomButtonWidget(
                              bgColor: AppColors.btnColor,
                              btnText: "Submit",
                              onTap: () {
                                if (otpFormC.text.isEmpty) {
                                  CustomToast.showToast("OTP input required",
                                      isError: true);
                                } else {
                                  _otpController.otpSubmit(
                                      otp: otpFormC.text,
                                      redirect: redirectFromView);
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
