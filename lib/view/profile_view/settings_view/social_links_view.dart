// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/controller/social_links_update_controller.dart';
import '../controller/profile_get_controller.dart';

class SocialLinksView extends StatefulWidget {
  const SocialLinksView({super.key});

  @override
  _SocialLinksViewState createState() => _SocialLinksViewState();
}

class _SocialLinksViewState extends State<SocialLinksView> {
  final ProfileGetController profileController = Get.put(ProfileGetController());
  final UpdateSocialLinkController _updateSocialLinkController = Get.put(UpdateSocialLinkController());

  TextEditingController instagramController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController spotifyController = TextEditingController();
  TextEditingController otherSocialController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initializing controllers with profile data
    instagramController.text = profileController.profile.value.data?.instagram ?? '';
    tiktokController.text = '';
    xController.text = profileController.profile.value.data?.x ?? '';
    spotifyController.text = profileController.profile.value.data?.spotify ?? '';
    otherSocialController.text = profileController.profile.value.data?.otherSocial ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Social Links"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                image: "assets/images/insta.png",
                hintText: "@username",
                controller: instagramController,
                showObscure: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                image: "assets/images/tiktok.png",
                hintText: "@username",
                controller: tiktokController,
                showObscure: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                image: "assets/images/XLogo.png",
                hintText: "@username",
                controller: xController,
                showObscure: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                image: "assets/images/rafi.png",
                hintText: "@username",
                controller: spotifyController,
                showObscure: false,
              ),
              SizedBox(height: 20),
              CustomTextField(
                hintTextColo: isDarkMode ? Colors.grey : Colors.black,
                iconColor: Colors.white,
                fillColor: isDarkMode ? Colors.black : Colors.white,
                borderColor: Colors.grey,
                image: "assets/images/rafi2.png",
                hintText: "@username",
                controller: otherSocialController,
                showObscure: false,
              ),
              // Done Button
              Spacer(),
              Obx(() {
                return _updateSocialLinkController.isLoading.value
                    ? CustomLoader()
                    : SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: CustomButtonWidget(
                    bgColor: AppColors.btnColor,
                    btnText: "Save",
                    onTap: () {
                      _updateSocialLinkController.updateSocial(
                        instagramController.text,
                        tiktokController.text,
                        xController.text,
                        spotifyController.text,
                        otherSocialController.text,
                      );
                    },
                    iconWant: false,
                  ),
                );
              }),
              SizedBox(height: 10.h),
              // Skip Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(
                  bgColor: Colors.white,
                  btnText: "Cancel",
                  btnTextColor: Colors.black,
                  onTap: () {
                    Get.back();
                  },
                  weight: FontWeight.w500,
                  iconWant: false,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(height: 26.h),
            ],
          ),
        ),
      );
    });
  }
}
