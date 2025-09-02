import 'package:flutter/material.dart';
import 'package:get/get.dart'; // For navigation (Get.to)
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/Remember_widget.dart';

class AccountPrivacyView extends StatefulWidget {
  const AccountPrivacyView({super.key});

  @override
  _AccountPrivacyViewState createState() => _AccountPrivacyViewState();
}

class _AccountPrivacyViewState extends State<AccountPrivacyView> {
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Account Privacy"),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: "Private Account",
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  RememberWidget(
                    isChecked: rememberMe,
                    onChanged: (value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                    text: "Remember me",
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomText(
                textAlign: TextAlign.start,
                color: isDarkMode ? Colors.white : Colors.black,
                text:
                    "When your account is public, others will be able to see your profile, events you have created and ones you have marked as “interested”.",
              )
            ],
          ),
        ),
      );
    });
  }
}
