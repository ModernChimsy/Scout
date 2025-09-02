// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/auth_view/controller/step_controller.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

import '../../uitilies/custom_toast.dart';
import 'controller/sign_up_controller.dart';

class ShareInterestView extends StatefulWidget {
  final String fullName;
  final String userName;
  final String email;
  final String password;

  const ShareInterestView({
    super.key,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  State<ShareInterestView> createState() => _ShareInterestViewState();
}

class _ShareInterestViewState extends State<ShareInterestView> {
  final StepController stepController = Get.put(StepController());
  final RegisterController _registerController = Get.put(RegisterController());

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
    'Outdoor',
  ];

  List<String> _filteredInterests = [];
  List<String> _selectedInterests = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredInterests = _interests;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInterests = _interests
          .where((item) => item.toLowerCase().contains(query))
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
    bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
        ThemeController.darkTheme;

    return Scaffold(
      body: Stack(
        children: [
          // Background
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
                color: isDarkMode ? AppColors.bgColor : Colors.transparent,
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80.h),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image(image: AssetImage("assets/images/long_logo.png")),
                    Obx(() {
                      return Row(
                        children: List.generate(3, (index) {
                          bool isActive =
                              index < stepController.currentStep.value;
                          return Container(
                            margin: EdgeInsets.only(left: 6.w),
                            width: isActive ? 19.w : 10.w,
                            height: isActive ? 14.h : 10.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.btnColor
                                  : Colors.grey.shade300,
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
                SizedBox(height: 30.h),

                // Title
                CustomText(
                  text: "Share your interests",
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                SizedBox(height: 5.h),
                CustomText(
                  textAlign: TextAlign.start,
                  text:
                  "Let’s personalise the events you see. You can update this later in the profile section.",
                  fontSize: 14.sp,
                  color: isDarkMode ? Colors.white : Colors.black54,
                ),

                SizedBox(height: 20.h),

                // Search
                Text("Search",
                    style: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w500)),
                SizedBox(height: 6.h),
                CustomTextField(
                  controller: _searchController,
                  fillColor: Colors.transparent,
                  borderColor: Colors.grey,
                  hintText: "Search here.....",
                  showObscure: false,
                  prefixIcon: Icons.search,
                ),
                SizedBox(height: 20.h),

                // Chips
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _filteredInterests.map((interest) {
                    bool isSelected = _selectedInterests.contains(interest);
                    return ChoiceChip(
                      label: Text(interest),
                      selected: isSelected,
                      onSelected: (_) => _toggleSelection(interest),
                      selectedColor: AppColors.btnColor,
                      backgroundColor: AppColors.btnColor.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isDarkMode
                            ? (isSelected ? Colors.black : Colors.white)
                            : (isSelected ? Colors.white : Colors.black),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      side: BorderSide.none,
                    );
                  }).toList(),
                ),

                Spacer(),

                // Done Button
                Obx(() {
                  return _registerController.isLoading.value
                      ? CustomLoader()
                      : SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: CustomButtonWidget(
                      bgColor: AppColors.btnColor,
                      btnText: "Done",
                      onTap: () {
                        if (_selectedInterests.isEmpty) {
                          CustomToast.showToast(
                              "Please select at least one interest.",
                              isError: true);
                          return;
                        }

                        _registerController.register(
                          firstName: widget.fullName,
                          lastName: widget.userName,
                          email: widget.email,
                          password: widget.password,
                          interests: _selectedInterests,
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
                    btnText: "Skip",
                    btnTextColor: Colors.black,
                    onTap: () {},
                    iconWant: false,
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

