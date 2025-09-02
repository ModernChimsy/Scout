import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_event/controller/theme_controller.dart'; // to access the theme controller

class StatBox extends StatelessWidget {
  final String title;
  final dynamic value;

  const StatBox({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark mode
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Column(
      children: [
        // Displaying the value
        Text(
          value.toString(),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black, // Adjust color based on dark mode
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),

        // Displaying the title
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54, // Adjust color based on dark mode
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
