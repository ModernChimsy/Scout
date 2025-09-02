// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class InterestedPage extends StatelessWidget {
  final List<Map<String, dynamic>> interested; // Use dynamic type for values

  const InterestedPage({super.key, required this.interested});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: const CustomAppBar(title: "Interested"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Interested',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16.h),

              // List of interested users
              interested.isEmpty
                  ? CustomText(
                text: 'No one has shown interest yet.',
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.sp,
              )
                  : ListView.builder(
                itemCount: interested.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  var user = interested[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: InterestedUserWidget(
                      color: isDarkMode ? Colors.white : Colors.black,
                      username: user['fullName'] ?? 'Unknown Username', // Fallback value
                      fullName: user['fullName'] ?? 'Unknown Name',     // Fallback value
                      imageUrl: user['profilePicture'] ?? 'default-image-url',    // Fallback value
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}


class InterestedUserWidget extends StatelessWidget {
  final String username;
  final String fullName;
  final String imageUrl;
  final Color color;

  const InterestedUserWidget({
    required this.username,
    required this.fullName,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // User Profile Image
        CircleAvatar(
          radius: 25.w,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(width: 10.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: username,
              color: color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            CustomText(
              text: fullName,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ],
        ),
      ],
    );
  }
}
