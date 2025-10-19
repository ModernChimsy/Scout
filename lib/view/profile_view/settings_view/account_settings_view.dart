// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/profile_get_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/account_privacy_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/my_details_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/my_interest_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/notification_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/social_links_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/theme_view.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/update_password_view.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/account_settings_top_section_widget.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/settings_card_widget.dart';
import '../../../auth/auth_manager.dart';
import '../widget/shimmer_profile_widget.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final ProfileGetController _profileGetController = Get.put(ProfileGetController());

  final AuthManager _authManager = AuthManager();
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    // Call the API to fetch profile data
    _profileGetController.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Account Settings"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: ListView(
            children: [
              SizedBox(height: 20),

              Obx(() {
                String name = _profileGetController.profile.value.data?.firstName ?? 'User';
                String profileImage = _profileGetController.profile.value.data?.profilePicture ?? '';
                String username = _profileGetController.profile.value.data?.lastName ?? '@username';

                return _profileGetController.isLoading.value == true
                    ? ShimmerProfileWidget()
                    : AccountSettingsProfileTopSection(
                        name: name,
                        color: isDarkMode ? Colors.white : Colors.black,
                        profileImage: profileImage.isEmpty
                            ? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png' // Default image
                            : profileImage,
                        username: username,
                      );
              }),

              const SizedBox(height: 20),

              // Information Section (not wrapped in Obx)
              CustomText(
                textAlign: TextAlign.start,
                text: 'Information',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 10),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'My Details',
                onTap: () {
                  Get.to(() => MyDetailsView());
                },
                image: 'assets/images/Note.png',
              ),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'My Interests',
                onTap: () {
                  Get.to(() => MyInterestView());
                },
                icon: null,
                image: 'assets/images/Star.png',
              ),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'Social Links',
                onTap: () {
                  Get.to(() => SocialLinksView());
                },
                icon: null,
                image: 'assets/images/Vector.png',
              ),

              // Preferences Section (not wrapped in Obx)
              const SizedBox(height: 20),
              CustomText(
                textAlign: TextAlign.start,
                text: 'Preferences',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 10),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'Account Privacy',
                onTap: () {
                  Get.to(() => AccountPrivacyView());
                },
                image: 'assets/images/Globe.png',
              ),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'Notifications',
                onTap: () {
                  Get.to(() => NotificationView());
                },
                image: 'assets/images/BellRinging.png',
              ),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'Theme',
                onTap: () {
                  Get.to(() => ThemePage());
                },
                image: 'assets/images/Sun.png',
              ),

              // Security Section (not wrapped in Obx)
              const SizedBox(height: 20),
              CustomText(
                textAlign: TextAlign.start,
                text: 'Security',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              const SizedBox(height: 10),
              SettingCard(
                iconColor: isDarkMode ? Colors.white : Colors.black,
                title: 'Update Password',
                onTap: () {
                  Get.to(() => ChangePasswordPage());
                },
                image: 'assets/images/Vector.png',
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
              ),
              SettingCard(
                textColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                title: 'Sign Out',
                onTap: () async {
                  await _authManager.signOut();
                },
                image: 'assets/images/Vector (1).png',
                iconColor: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
          ),
        ),
      );
    });
  }
}
