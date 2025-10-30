// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/widget/toogle_for_event.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';

class ExtraView extends StatefulWidget {
  const ExtraView({super.key});

  @override
  _ExtraViewState createState() => _ExtraViewState();
}

class _ExtraViewState extends State<ExtraView> {
  final StorageService _storageService = StorageService();

  bool coatCheck = false;
  bool ownAlcohol = false;

  @override
  void initState() {
    super.initState();
    _loadSavedOptions();
  }

  void _loadSavedOptions() async {
    final bool? coatCheckSaved = _storageService.read<bool>('coatCheck');
    final bool? alcoholSaved = _storageService.read<bool>('ownAlcohol');

    setState(() {
      coatCheck = coatCheckSaved ?? false;
      ownAlcohol = alcoholSaved ?? false;
    });
  }

  void _saveOptionsAndExit() async {
    try {
      if (!coatCheck && !ownAlcohol) {
        CustomToast.showToast("No extra options selected.", isError: false);
      }

      await _storageService.write('coatCheck', coatCheck);
      await _storageService.write('ownAlcohol', ownAlcohol);

      CustomToast.showToast("Extra options saved successfully.");

      Get.back();
    } catch (e) {
      CustomToast.showToast("Failed to save options.", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Extra"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              ToggleForEvent(
                textColor: isDarkMode ? Colors.white : Colors.black,
                color: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                title: "Coat check",
                isChecked: coatCheck,
                onChanged: (value) {
                  setState(() {
                    coatCheck = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              ToggleForEvent(
                textColor: isDarkMode ? Colors.white : Colors.black,
                color: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                title: "Own alcohol allowed",
                isChecked: ownAlcohol,
                onChanged: (value) {
                  setState(() {
                    ownAlcohol = value;
                  });
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveOptionsAndExit, iconWant: false),
              ),
              SizedBox(height: 46.h),
            ],
          ),
        ),
      );
    });
  }
}
