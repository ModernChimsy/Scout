// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/hide_from_another_view.dart';
import 'package:restaurent_discount_app/view/create_event/widget/event_card_widget.dart';
import 'package:restaurent_discount_app/view/create_event/widget/toogle_for_event.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import '../profile_view/settings_view/invite_user_view.dart';
import 'create_event_view.dart';

class EventVisibilityView extends StatefulWidget {
  const EventVisibilityView({super.key});

  @override
  _EventVisibilityViewState createState() => _EventVisibilityViewState();
}

class _EventVisibilityViewState extends State<EventVisibilityView> {
  bool isPrivate = false;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();
    _loadPrivacySetting();
  }

  void _loadPrivacySetting() async {
    bool? savedValue = _storageService.read<bool>('eventPrivate');
    if (savedValue != null) {
      setState(() {
        isPrivate = savedValue;
      });
    }
  }

  void _saveAndExit() async {
    await _storageService.write('eventPrivate', isPrivate);

    CustomToast.showToast("Event visibility updated to ${isPrivate ? 'Private' : 'Public'}", isError: false);

    Get.to(() => CreateEventView());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Event visibility"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              ToggleForEvent(
                textColor: isDarkMode ? Colors.white : Colors.black,
                color: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                title: "Event is private",
                isChecked: isPrivate,
                onChanged: (value) {
                  setState(() {
                    isPrivate = value;
                  });
                  _storageService.write('eventPrivate', value);
                },
              ),
              SizedBox(height: 20.h),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => HideEventPage());
                },
                title: "Hide from others",
              ),
              SizedBox(height: 20.h),
              EventCardWidget(
                bgColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                textColor: isDarkMode ? Colors.white : Colors.black,
                onTap: () {
                  Get.to(() => InviteUserView());
                },
                title: "Invite User",
              ),

              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveAndExit, iconWant: false),
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
