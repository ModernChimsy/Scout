import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class AppColors {
  static Color scoutVividVermilion = const Color(0xFFFB6012); // using this as the main color across app
  static Color mainColor = const Color(0xFF0065FF);
  static Color tabActiveColorLight = const Color(0xFFFB6012);
  static Color tabInActiveColorLight = const Color(0xFFFFF5F0);
  static Color tabActiveColorDark = const Color(0xFFFDAF88);
  static Color tabInActiveColorDark = const Color(0x804B5155);
  static Color btnColor = const Color(0xFFFB6012);
  static Color btnBorderColor = const Color(0xFF050505);

  static Color get bgColor {
    if (Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme) {
      return Colors.black;
    } else {
      return const Color(0xFFFFF5F0);
    }
  }

  // Gradient for background depending on the theme
  static Gradient get gradient {
    if (Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme) {
      return LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withOpacity(0.7), Colors.black]);
    } else {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.white.withOpacity(0.5), Colors.white],
      );
    }
  }
}
