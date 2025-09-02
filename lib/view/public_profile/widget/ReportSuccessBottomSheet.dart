import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../create_event/controller/theme_controller.dart';

class ReportSuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 4,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            indent: 150,
            endIndent: 150,
          ),
          Icon(
            Icons.shield,
            color: isDarkMode
                ? Colors.orange
                : Colors.blue, // Icon color based on dark mode
            size: 48,
          ),
          SizedBox(height: 20),
          Text(
            'Thank you for your report',
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white
                  : Colors.black, // Text color based on dark mode
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Our team will revise the information provided and make a decision in 72 hours.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDarkMode
                  ? Colors.white70
                  : Colors.black87, // Text color based on dark mode
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black), // Button text color based on dark mode
            ),
          ),
        ],
      ),
    );
  }
}
