// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

import '../../create_event/controller/theme_controller.dart'; // Import theme controller

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Scaffold(
      backgroundColor: isDarkMode ? AppColors.bgColor : Colors.white,
      appBar: CustomAppBar(title: "Theme"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildRadioTile(
              value: 'light',
              label: 'Light mode',
              icon: Icons.wb_sunny,
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 10),
            _buildRadioTile(
              value: 'dark',
              label: 'Dark mode',
              icon: Icons.nights_stay,
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 10),
            _buildRadioTile(
              value: 'system',
              label: 'System default',
              icon: Icons.phone_iphone,
              isDarkMode: isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioTile({
    required String value,
    required String label,
    required IconData icon,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          themeController.setTheme(value);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: themeController.selectedTheme == value
              ? AppColors.btnColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.white : Colors.grey[400]!,
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: themeController.selectedTheme == value
                      ? AppColors.btnColor
                      : isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                SizedBox(width: 8),
                CustomText(
                  text: label,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: themeController.selectedTheme == value
                      ? AppColors.btnColor
                      : isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              ],
            ),
            Radio<String>(
              activeColor: AppColors.btnColor,
              value: value,
              groupValue: themeController.selectedTheme,
              onChanged: (String? newValue) {
                setState(() {
                  themeController.setTheme(newValue!);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
