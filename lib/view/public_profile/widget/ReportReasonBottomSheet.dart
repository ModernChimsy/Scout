import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import '../../create_event/controller/theme_controller.dart';
import 'ReportSuccessBottomSheet.dart';

class ReportReasonBottomSheet extends StatelessWidget {
  final List<String> reasons = [
    'This is spam',
    'Misleading or possible scam',
    'False information',
    'Impersonation of an individual or business',
    'Hate speech or symbols',
  ];

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark mode
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 4,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            indent: 150,
            endIndent: 150,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              textAlign: TextAlign.start,
              text: 'Report account',
              color: isDarkMode ? Colors.white : Colors.black, // Adjust text color based on dark mode
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // Map the reasons list into ListTile widgets
          ...reasons.map((reason) => ListTile(
            title: CustomText(
              textAlign: TextAlign.start,
              text: reason,
              color: isDarkMode ? Colors.white : Colors.black, // Adjust text color based on dark mode
            ),
            onTap: () {
              Get.back();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => ReportSuccessBottomSheet(),
              );
            },
          )),
          ListTile(
            title: CustomText(
              textAlign: TextAlign.start,
              text: 'Cancel',
              color: Colors.redAccent, // Red stays the same
            ),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
