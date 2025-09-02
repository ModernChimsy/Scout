// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/sign_in_controller.dart';
import 'package:restaurent_discount_app/view/auth_view/forget_password_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import 'create_account.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  final SignInController _signInController = Get.put(SignInController());

  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Stack(
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
                            color: isDarkMode
                                ? AppColors.bgColor
                                : Colors.transparent,
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

                      // Main content
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image(
                                    image: AssetImage(
                                        "assets/images/long_logo.png")),
                              ],
                            ),
                            SizedBox(height: 30.h),
                            CustomText(
                              text: "Welcome back",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            SizedBox(height: 5.h),
                            CustomText(
                              text: "Create your login details below",
                              fontSize: 14.sp,
                              color:
                                  isDarkMode ? Colors.white54 : Colors.black54,
                            ),
                            SizedBox(height: 20.h),
                            CustomText(
                                text: "Email",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500),
                            SizedBox(height: 6.h),
                            CustomTextField(
                              controller: emailC,
                              fillColor: Colors.transparent,
                              borderColor: Colors.grey,
                              hintText: "Enter your email",
                              showObscure: false,
                            ),
                            SizedBox(height: 10.h),
                            CustomText(
                              color: isDarkMode ? Colors.white : Colors.black,
                              text: "Password",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: 6.h),
                            CustomTextField(
                              controller: passwordC,
                              fillColor: Colors.transparent,
                              borderColor: Colors.grey,
                              hintText: "Enter your password",
                              showObscure: true,
                            ),
                            SizedBox(height: 10.h),
                            Align(
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ForgetPasswordView());
                                  },
                                  child: Text(
                                    "Forgot password ?",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14.sp,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.grey,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )),
                            SizedBox(height: 30.h),
                            Obx(() {
                              return _signInController.isLoading.value
                                  ? CustomLoader()
                                  : SizedBox(
                                      width: double.infinity,
                                      height: 48.h,
                                      child: CustomButtonWidget(
                                        bgColor: AppColors.btnColor,
                                        btnText: "Sign in",
                                        onTap: () {
                                          if (emailC.text.isEmpty ||
                                              passwordC.text.isEmpty) {
                                            return CustomToast.showToast(
                                                "All fields are required",
                                                isError: true);
                                          } else {
                                            _signInController.login(
                                                email: emailC.text,
                                                password: passwordC.text);
                                          }
                                        },
                                        iconWant: false,
                                      ),
                                    );
                            }),
                            SizedBox(height: 10.h),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: "New here? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Create an Account",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: isDarkMode
                                            ? Colors.orangeAccent
                                            : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateAccountView(),
                                            ),
                                          );
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
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
