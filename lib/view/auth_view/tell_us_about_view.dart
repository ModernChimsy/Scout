// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/step_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/share_interest_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class TellUsAboutYou extends StatelessWidget {
  final String email;
  final String password;

  TellUsAboutYou({super.key, required this.email, required this.password});

  final StepController stepController = Get.put(StepController());

  final TextEditingController fullNameC = TextEditingController();
  final TextEditingController userNameC = TextEditingController();

  static const String orangeLogoPath = "assets/icon/scout_logo_orange.svg";
  static final Color _inactiveIndicatorColor = AppColors.btnColor.withOpacity(0.3);
  static const double _pillHeight = 6.0;
  static const double _activePillWidth = 18.0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      Color textColor = isDarkMode ? Colors.white : Colors.black;
      Color subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

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
                          colors: [AppColors.scoutVividVermilion.withOpacity(0.1), Color(0xFFFFA07A).withOpacity(0.1)],
                        ),
                  color: isDarkMode ? AppColors.bgColor : Colors.transparent,
                ),
              ),
            ),

            Positioned.fill(
              child: Container(decoration: BoxDecoration(gradient: isDarkMode ? null : AppColors.gradient)),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(orangeLogoPath, height: 20.h),

                      Obx(() {
                        final int currentStepIndex = stepController.currentStep.value - 1;
                        return Row(
                          children: List.generate(3, (index) {
                            final bool isCurrent = index == currentStepIndex;
                            final double height = _pillHeight.h;
                            final double width = isCurrent ? _activePillWidth.w : _pillHeight.w;
                            final BoxShape shape = isCurrent ? BoxShape.rectangle : BoxShape.circle;
                            final BorderRadius? borderRadius = isCurrent ? BorderRadius.circular(height / 2) : null;
                            final Color color = index < currentStepIndex
                                ? AppColors.btnColor
                                : (isCurrent ? AppColors.btnColor : _inactiveIndicatorColor);

                            return Container(
                              margin: EdgeInsets.only(left: 6.w),
                              width: width,
                              height: height,
                              decoration: BoxDecoration(shape: shape, borderRadius: borderRadius, color: color),
                            );
                          }),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Title
                  CustomText(text: "Tell us about you", fontSize: 20.sp, fontWeight: FontWeight.bold, color: textColor),
                  SizedBox(height: 5.h),
                  // Subtitle
                  CustomText(textAlign: TextAlign.start, text: "Let’s create your profile", fontSize: 14.sp, color: subtitleColor),

                  SizedBox(height: 30.h),

                  // Full Name Field
                  CustomText(text: "Full Name", color: textColor, fontSize: 14.sp, fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: fullNameC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your full name",
                    showObscure: false,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  SizedBox(height: 10.h),

                  // Username Field
                  CustomText(text: "Username*", fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500),
                  SizedBox(height: 6.h),
                  CustomTextField(
                    controller: userNameC,
                    fillColor: Colors.transparent,
                    borderColor: Colors.grey,
                    hintText: "Enter your username",
                    showObscure: false,
                    hintTextColo: subtitleColor,
                    iconColor: textColor,
                  ),

                  SizedBox(height: 10.h),

                  CustomText(
                    textAlign: TextAlign.start,
                    text: "*Your username is what your friends will use to find your public profile.",
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
                          CustomToast.showToast("Please fill out all fields", isError: true);
                        } else {
                          stepController.nextStep();
                          Get.to(() => ShareInterestView(fullName: fullName, userName: userName, email: email, password: password));
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
