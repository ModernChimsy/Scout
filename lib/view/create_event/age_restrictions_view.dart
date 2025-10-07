// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/widget/toogle_for_event.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';

class AgesRestrictionView extends StatefulWidget {
  const AgesRestrictionView({super.key});

  @override
  _AgesRestrictionViewState createState() => _AgesRestrictionViewState();
}

class _AgesRestrictionViewState extends State<AgesRestrictionView> {
  final TextEditingController ageController = TextEditingController();
  final StorageService _storageService = StorageService();
  final FocusNode _focusNode = FocusNode();

  bool isAgeRestricted = false;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    ageController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _saveAndExit();
        }
      });
    }
  }

  void _loadSavedValues() async {
    final savedAge = _storageService.read<String>('minAgeRestriction');
    final savedToggle = _storageService.read<bool>('isAgeRestricted');

    if (savedAge != null) {
      ageController.text = savedAge;
    }
    if (savedToggle != null) {
      setState(() {
        isAgeRestricted = savedToggle;
      });
    }
  }

  Future<void> _saveAndExit() async {
    final age = ageController.text.trim();

    if (isAgeRestricted) {
      if (age.isEmpty) {
        CustomToast.showToast("Please enter a minimum age restriction.", isError: true);
        return;
      }
      if (int.tryParse(age) == null || int.parse(age) < 1) {
        CustomToast.showToast("Please enter a valid age (number greater than 0).", isError: true);
        return;
      }
    }

    await _storageService.write('minAgeRestriction', age);
    await _storageService.write('isAgeRestricted', isAgeRestricted);

    CustomToast.showToast("Age restriction saved.", isError: false);

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Age Restrictions"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Minimum age restrictions",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: ageController,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                fillColor: Colors.transparent,
                borderColor: Colors.grey,
                hintText: "Enter minimum age restriction",
                showObscure: false,
                onSubmitted: (_) => _saveAndExit(),
              ),
              SizedBox(height: 15),

              ToggleForEvent(
                textColor: isDarkMode ? Colors.white : Colors.black,
                color: isDarkMode ? Color(0xFF4B515580) : Color(0xFFFFF5F0),
                title: "Event is age restricted",
                isChecked: isAgeRestricted,
                onChanged: (value) async {
                  setState(() {
                    isAgeRestricted = value;
                  });
                  await _storageService.write('isAgeRestricted', value);
                },
              ),

              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveAndExit, iconWant: false),
              ),
              SizedBox(height: 26.h),
            ],
          ),
        ),
      );
    });
  }
}
