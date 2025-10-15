import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';

class AppColors {
  static Color mainColor = const Color(0xFF0065FF);
  static Color btnColor = const Color(0xFFFB6012);
  static Color btnBorderColor = const Color(0xFF050505);

  static Color get bgColor {
    if (Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme) {
      return Colors.black;
    } else {
      return const Color(0xFFFFFFFF);
    }
  }

  // Gradient for background depending on the theme
  static Gradient get gradient {
    if (Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.black.withOpacity(0.7), Colors.black],
      );
    } else {
      return LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.white.withOpacity(0.5),
          Colors.white,
        ], // Light gradient for light theme
      );
    }
  }
}
