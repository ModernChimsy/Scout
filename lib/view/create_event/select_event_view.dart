// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/create_event_view.dart';
import 'package:restaurent_discount_app/uitilies/enums.dart';

class SelectEventView extends StatefulWidget {
  const SelectEventView({super.key});

  @override
  State<SelectEventView> createState() => _SelectEventViewState();
}

class _SelectEventViewState extends State<SelectEventView> {
  static final log = Logger();
  static const String checkMarkPath = "assets/icon/check_circle.svg";

  EventType _selectedEventType = EventType.core;

  late final bool isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
  }

  Widget _buildEventOption({required EventType type, required String title, required String price, required List<String> features}) {
    final isSelected = _selectedEventType == type;

    final Color cardColor = isDarkMode ? AppColors.cardBackgroundDark : Colors.white;

    final Color unselectedBorderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400;
    final Color borderColor = isSelected ? AppColors.btnColor : unselectedBorderColor;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color featureColor = isDarkMode ? Colors.white70 : Colors.black87;

    final Color corePriceBgColor = Color(0xFFE94E1B);
    final Color priceBgColor = type == EventType.core ? corePriceBgColor : AppColors.btnColor;

    final Color selectedDarkCardColor = Color(0xFF333333);
    final Color finalCardColor = isSelected && isDarkMode ? selectedDarkCardColor : cardColor;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedEventType = type;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: finalCardColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? AppColors.btnColor : unselectedBorderColor, width: isSelected ? 2.0 : 1.0),
          boxShadow: isSelected && !isDarkMode ? [BoxShadow(color: AppColors.btnColor.withOpacity(0.2), blurRadius: 5, spreadRadius: 1)] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text: title, color: textColor, fontSize: 20.sp, fontWeight: FontWeight.bold),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(color: priceBgColor, borderRadius: BorderRadius.circular(10)),
                  child: CustomText(text: price, color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ...features.map((feature) => _buildFeatureRow(feature, featureColor)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(checkMarkPath, height: 20.h),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              textAlign: TextAlign.start,
              text: text,
              color: color,
              fontSize: 14.sp,
              fontWeight: _selectedEventType == EventType.dynamicEvent && isDarkMode && text != 'Everything in Core, plus:'
                  ? FontWeight.w400
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color scaffoldBgColor = isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF2F2F2);

    final systemOverlayStyle = SystemUiOverlayStyle(
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        systemOverlayStyle: systemOverlayStyle,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: CustomText(text: 'Select event type', color: isDarkMode ? Colors.white : Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),
        centerTitle: false,
        toolbarHeight: 50.h,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: AppPadding.bodyPadding,
        child: Column(
          children: [
            SizedBox(height: 20.h),

            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildEventOption(
                      type: EventType.core,
                      title: 'Core',
                      price: 'Free',
                      features: [
                        'Create public or private events',
                        'Display core event information',
                        'Add event tags to boost your event\'s visibility',
                      ],
                    ),

                    // TODO: Enable this for Phase II
                    /*_buildEventOption(
                      type: EventType.dynamicEvent,
                      title: 'Dynamic',
                      price: 'R150',
                      features: [
                        'Everything in Core, plus:',
                        'Share ticket links to boost sales',
                        'Showcase multiple-day, multi-stage lineups',
                        'Add artists, venues, vendors, brands and event partners.',
                      ],
                    ),*/
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),

            CustomButtonWidget(
              bgColor: AppColors.btnColor,
              btnText: _selectedEventType == EventType.core ? "Next" : "Proceed to payment",
              onTap: () {
                if (_selectedEventType == EventType.core) {
                  Get.to(() => const CreateEventView());
                } else {
                  // Get.to(() => const CreatePaidEventView());
                  log.d("➡️ This is where your Paid Event Selector goes.");
                }
              },
              iconWant: false,
            ),
            SizedBox(height: 10.h),
            CustomButtonWidget(
              weight: FontWeight.w500,
              btnTextColor: isDarkMode ? Colors.white : Colors.black,
              bgColor: Colors.transparent,
              btnText: "Cancel",
              onTap: () {
                Get.back();
              },
              iconWant: false,
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
