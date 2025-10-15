// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/bookmarks_view/bookmarks_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/home_view/home_view.dart';
import 'package:restaurent_discount_app/view/profile_view/controller/profile_get_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/profile_view.dart';
import 'package:restaurent_discount_app/view/search_view/search_view.dart';

class BottomNavBarExample extends StatefulWidget {
  const BottomNavBarExample({super.key});

  @override
  State<BottomNavBarExample> createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomeScreen(), EventCategoryScreen(), BookmarksView(), ProfileScreen()];

  final ProfileGetController _profileGetController = Get.put(ProfileGetController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      String profilePictureUrl = _profileGetController.profile.value.data?.profilePicture ?? '';

      String finalProfilePictureUrl = profilePictureUrl.isEmpty ? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png' : profilePictureUrl;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_outline_outlined), label: ''),
            BottomNavigationBarItem(
              icon: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: AppColors.btnColor, width: 3),
                ),
                child: CircleAvatar(backgroundImage: NetworkImage(finalProfilePictureUrl)),
              ),
              label: '',
            ),
          ],
          selectedItemColor: AppColors.btnColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 10,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
        ),
      );
    });
  }
}
