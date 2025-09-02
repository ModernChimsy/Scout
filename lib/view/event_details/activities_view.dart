// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/no_data_found_widget.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import '../../common widget/custom text/custom_text_widget.dart';

class ActivitiesPage extends StatelessWidget {
  final List<Map<String, String>> activities; // Accepting list of activities

  const ActivitiesPage({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Activities"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                color: isDarkMode ? Colors.white : Colors.black,
                text: 'Activities',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16.h),

              // 🔥 Check if activities list is empty
              activities.isEmpty
                  ? Center(child: NotFoundWidget(message: "No Activity Found"))
                  : ListView.builder(
                      itemCount: activities.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var activity = activities[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: ActivityRowWidget(
                            artistName: activity['artist'] ?? 'Unknown',
                            time: activity['time'] ?? '--:--',
                            color: isDarkMode ? Colors.white : Colors.black,
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

class ActivityRowWidget extends StatelessWidget {
  final String artistName;
  final String time;
  final Color color;

  const ActivityRowWidget({
    required this.artistName,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          text: artistName,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF174091),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: CustomText(
              text: time,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
