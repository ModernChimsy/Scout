import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/public_profile/controller/get_public_controller.dart';

import '../../create_event/controller/theme_controller.dart';

class UrlsBottomSheet extends StatelessWidget {
  final PublicProfileController _publicProfileController =
  Get.put(PublicProfileController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

    // Retrieve the usernames
    final String? instagramUsername =
        _publicProfileController.nurseData.value.data?.instagram;
    final String? xUsername = _publicProfileController.nurseData.value.data?.x;
    final String? otherUsername =
        _publicProfileController.nurseData.value.data?.otherSocial;
    final String? spotify =
        _publicProfileController.nurseData.value.data?.spotify;

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
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              indent: 150,
              endIndent: 150),

          // Instagram Username
          if (instagramUsername != null && instagramUsername.isNotEmpty)
            ListTile(
              leading: Image.asset(
                "assets/images/insta.png",
                color: isDarkMode ? Colors.white : Colors.black,
                scale: 4,
              ),
              title: Text(
                '$instagramUsername',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),

          if (xUsername != null && xUsername.isNotEmpty)
            ListTile(
              leading: Image.asset(
                "assets/images/XLogo.png",
                color: isDarkMode ? Colors.white : Colors.black,
                scale: 4,
              ),
              title: Text(
                '$xUsername',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),

          if (spotify != null && spotify.isNotEmpty)
            ListTile(
              leading: Image.network(
                "http://static-00.iconduck.com/assets.00/spotify-icon-2048x2048-n3imyp8e.png",
                color: isDarkMode ? Colors.white : Colors.black,
                scale: 70,
              ),
              title: Text(
                '$spotify',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),

          if (otherUsername != null && otherUsername.isNotEmpty)
            ListTile(
              leading: Icon(
                Icons.link,
                color: isDarkMode ? Colors.white : Colors.black,
              ), // Other link icon
              title: Text(
                'Other: $otherUsername',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
