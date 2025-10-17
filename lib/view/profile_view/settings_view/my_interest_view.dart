// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/controller/my_interest_controller.dart';

import '../../../uitilies/custom_loader.dart';
import '../controller/profile_get_controller.dart';

class MyInterestView extends StatefulWidget {
  const MyInterestView({super.key});

  @override
  _MyInterestViewState createState() => _MyInterestViewState();
}

class _MyInterestViewState extends State<MyInterestView> {
  final List<String> _interests = [
    'Festival',
    'Food',
    'Wine',
    'Sports',
    'Literature',
    'Concerts',
    'Nightlife',
    'Tech',
    'Music',
    'Art',
    'Fundraising',
    'Outdoor'
  ];

  List<String> _selectedInterests = [];

  final ProfileGetController profileController =
  Get.find<ProfileGetController>();


 final UpdateInterestController _updateInterestController = Get.put(UpdateInterestController());



  @override
  void initState() {
    super.initState();

    List<String> userInterests = profileController.profile.value.data?.interest ?? [];

    setState(() {
      _selectedInterests = _interests
          .where((interest) => userInterests
          .map((e) => e.toLowerCase())
          .contains(interest.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "My Interests"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Search Bar
              Text(
                "Search",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6.h),
              CustomTextField(
                fillColor: Colors.transparent,
                borderColor: Colors.grey,
                hintText: "Search here.....",
                showObscure: false,
                trailingIcon: Icons.search,
              ),

              SizedBox(height: 20.h),

              // Interests Chips
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _interests.map((interest) {
                  bool isSelected = _selectedInterests.contains(interest);
                  return ChoiceChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (selected) {
                      _toggleSelection(interest);
                    },
                    selectedColor: AppColors.btnColor,
                    backgroundColor: Color(0xFFF4F4F4),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                    side: BorderSide.none,
                  );
                }).toList(),
              ),

              Spacer(),

              // Save Button
              Obx(() {
                return _updateInterestController.isLoading.value == true
                    ? CustomLoader()
                    : SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: CustomButtonWidget(
                    bgColor: AppColors.btnColor,
                    btnText: "Save",
                    onTap: () {
                      _updateInterestController.updateInterest(
                        interests: _selectedInterests,
                      );
                    },
                    iconWant: false,
                  ),
                );
              }),

              SizedBox(height: 10.h),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(
                  weight: FontWeight.w500,
                  bgColor: Colors.white,
                  btnText: "Cancel",
                  btnTextColor: Colors.black,
                  onTap: () {
                    Get.back();
                  },
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

