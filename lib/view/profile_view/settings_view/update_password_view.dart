// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/controller/change_password_controller.dart';

import '../../../uitilies/custom_toast.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Controllers for each input field
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final ChangePasswordController _changePasswordController = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Change Password"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                hintText: "Current Password",
                showObscure: true,
                controller: currentPasswordController,
              ),
              SizedBox(height: 10),
              // New Password Field
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                hintText: "New Password",
                showObscure: true,
                controller: newPasswordController,
                borderColor: Colors.grey,
              ),
              SizedBox(height: 10),
              // Confirm New Password Field
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                hintText: "Confirm Password",
                showObscure: true,
                controller: confirmPasswordController,
                borderColor: Colors.grey,
              ),
              SizedBox(height: 20),
              // Password Requirements
              CustomText(
                textAlign: TextAlign.start,
                text: "Password Requirements:",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              SizedBox(height: 8),
              // _buildPasswordRequirement("Minimum 8 characters"),
              // _buildPasswordRequirement("At least 1 uppercase letter"),
              // _buildPasswordRequirement("At least 1 lowercase letter"),
              // _buildPasswordRequirement("At least 1 number"),
              // _buildPasswordRequirement("At least 1 special character (!@#\$%^&*)"),

              // Add space before the button section
              SizedBox(height: 40),
              Spacer(),
              // Buttons (Update and Cancel)
              _changePasswordController.isLoading.value
                  ? Center(child: CustomLoader())
                  : CustomButtonWidget(
                bgColor: AppColors.btnColor,
                btnText: "Update",
                onTap: () {
                  _handlePasswordChange();
                },
                iconWant: false,
              ),
              SizedBox(height: 10.h),

              // Cancel Button
              CustomButtonWidget(
                weight: FontWeight.w500,
                bgColor: Colors.white,
                btnText: "Cancel",
                btnTextColor: Colors.black,
                onTap: () {
                  Get.back();
                },
                iconWant: false,
              ),
            ],
          ),
        ),
      );
    });
  }

  // // Widget to build each password requirement
  // Widget _buildPasswordRequirement(String requirement) {
  //   bool isDarkMode =
  //       Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
  //   return Row(
  //     children: [
  //       Icon(Icons.check, color: Colors.green, size: 16),
  //       SizedBox(width: 8),
  //       CustomText(
  //         text: requirement,
  //         fontSize: 14,
  //         fontWeight: FontWeight.w400,
  //         color: isDarkMode ? Colors.white : Colors.black,
  //       ),
  //     ],
  //   );
  // }

  // Method to handle password change
  void _handlePasswordChange() {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      CustomToast.showToast("Please fill in all fields", isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      CustomToast.showToast("New password and confirm password do not match", isError: true);
      return;
    }

    // Call the controller method to change the password
    _changePasswordController.changePassword(
      oldPass: currentPassword,
      newPass: newPassword,
    );
  }
}
