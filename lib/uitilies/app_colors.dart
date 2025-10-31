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
  static Color cardBackgroundLight = const Color(0xFFF4F4F4);
  static Color cardBackgroundDark = const Color(0xFF25282A);

  /// Event Create:
  static Color unselectedDarkCardBg = const Color(0x804B5155);
  static Color selectedDarkCardBg = const Color(0x99742802);
  static Color unselectedLightCardBg =  const Color(0xFFFFFFFF);
  static Color selectedLightCardBg = const Color(0xFFFFF5F0);

  /// Category Chip Colors Start:
  /// Nightlife
  static Color nightlifeLight = const Color(0xffcfd6fe);
  static Color nightlifeDark = const Color(0xFF1E1BA9);

  /// Music
  static Color musicLight = const Color(0xfff7ddca);
  static Color musicDark = const Color(0xFF5F2902);

  /// Food
  // static Color foodLight = const Color(0xFFe0ffe0);
  // static Color foodDark = const Color(0xFF4B8A3B);

  /// Default/Other Category
  static Color defaultLight = const Color(0x33fb6012);
  static Color defaultDark = const Color(0xFF742802);

  /// Theme-aware method to get Category Chip Background Color
  static Color getCategoryBgColor(String category) {
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    switch (category.toLowerCase()) {
      case 'nightlife':
        return isDarkMode ? nightlifeDark : nightlifeLight;
      case 'music':
        return isDarkMode ? musicDark : musicLight;
      // case 'food':
      //   return isDarkMode ? foodDark : foodLight;
      default:
        return isDarkMode ? defaultDark : defaultLight;
    }
  }

  static Color getCategoryMoreColor() {
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
    return isDarkMode ? const Color(0xFF292C2F).withOpacity(0.5) : const Color(0xfff2f2f2);
  }

  /// Category Chip Colors End: ----------------------------------------------------------------------------------------------------------------------

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
      return LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.white.withOpacity(0.5), Colors.white]);
    }
  }
}
