// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/public_profile/controller/block_user_controller.dart';
import '../../create_event/controller/theme_controller.dart';
import '../controller/get_public_controller.dart';
import 'ReportReasonBottomSheet.dart';

class MoreOptionsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark mode
    bool isDarkMode =
        Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    final _publicProfileController = Get.find<PublicProfileController>();

    final BlockUserController _blockUserController =
        Get.put(BlockUserController());
    final bool isBlocked =
        _publicProfileController.nurseData.value.data?.isBlockedByMe ?? false;

    final dynamic userId = _publicProfileController.nurseData.value.data?.id;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            thickness: 4,
            color: isDarkMode
                ? Colors.grey[700]
                : Colors.grey[300], // Adjust divider color
            indent: 150,
            endIndent: 150,
          ),
          ListTile(
            title: Text(
              'Copy profile URL',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white
                    : Colors.black, // Adjust text color for light/dark mode
              ),
            ),
            onTap: () {
              Get.back(); // Close sheet
              // Add logic to copy URL
            },
          ),
          ListTile(
            title: Text(
              'Report account',
              style: TextStyle(
                color: Colors.red, // Red stays the same
              ),
            ),
            onTap: () {
              Get.back(); // Close current sheet
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => ReportReasonBottomSheet(),
              );
            },
          ),
          // Conditional rendering for Block/Unblock
          ListTile(
            title: Text(
              isBlocked ? 'Unblock account' : 'Block account',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () {
              _blockUserController.block(userId: userId);
            },
          ),
          ListTile(
            title: Text(
              'Cancel',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            onTap: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
