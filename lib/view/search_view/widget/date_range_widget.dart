// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class DateRangePickerPage extends StatefulWidget {
  final Function(DateTimeRange) onDateRangeSelected;

  const DateRangePickerPage({super.key, required this.onDateRangeSelected});

  @override
  _DateRangePickerPageState createState() => _DateRangePickerPageState();
}

class _DateRangePickerPageState extends State<DateRangePickerPage> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      return Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: DateTime.now(),
              selectedDayPredicate: (day) {
                if (_selectedRange == null) return false;
                return day.isAfter(_selectedRange!.start.subtract(Duration(days: 1))) &&
                    day.isBefore(_selectedRange!.end.add(Duration(days: 1)));
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  if (_selectedRange == null || selectedDay.isBefore(_selectedRange!.start)) {
                    _selectedRange = DateTimeRange(start: selectedDay, end: selectedDay);
                  } else {
                    _selectedRange = DateTimeRange(start: _selectedRange!.start, end: selectedDay);
                  }
                });
              },
            ),
            SizedBox(height: 40),
            Padding(
              padding: AppPadding.bodyPadding,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: CustomButtonWidget(
                      bgColor: AppColors.btnColor,
                      btnText: "Apply Filter",
                      onTap: () {
                        if (_selectedRange != null) {
                          widget.onDateRangeSelected(_selectedRange!);
                        } else {
                          Get.snackbar("Select Date", "Please choose a valid date range!");
                        }
                      },
                      iconWant: false,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: CustomButtonWidget(
                      weight: FontWeight.w500,
                      bgColor: Colors.transparent,
                      btnText: "Clear",
                      btnTextColor: isDarkMode ? Colors.white : Colors.black,
                      onTap: () {
                        setState(() {
                          _selectedRange = null;
                        });
                      },
                      iconWant: false,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
    });
  }
}
