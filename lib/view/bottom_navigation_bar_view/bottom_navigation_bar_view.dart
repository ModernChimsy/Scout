// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/bookmarks_view/bookmarks_view.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/create_event/create_event_view.dart';
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

  final List<Widget> _pages = [HomeScreen(), EventCategoryScreen(), CreateEventView(), BookmarksView(), ProfileScreen()];

  final ProfileGetController _profileGetController = Get.put(ProfileGetController());

  final List<IconData> _regularIcons = const [Icons.home_outlined, Icons.search_outlined, Icons.add_box_outlined, Icons.bookmark_border_outlined];

  final List<IconData> _activeIcons = const [Icons.home_filled, Icons.search, Icons.add_box_rounded, Icons.bookmark];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      Color itemColor = isDarkMode ? Colors.white : Colors.black;
      Color activeItemColor = AppColors.btnColor;

      String profilePictureUrl = _profileGetController.profile.value.data?.profilePicture ?? '';
      String finalProfilePictureUrl = profilePictureUrl.isEmpty ? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png' : profilePictureUrl;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          elevation: 0,
          items: [
            // Home
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? _activeIcons[0] : _regularIcons[0], color: _currentIndex == 0 ? activeItemColor : itemColor),
              label: '',
            ),
            // Search
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1 ? _activeIcons[1] : _regularIcons[1], color: _currentIndex == 1 ? activeItemColor : itemColor),
              label: '',
            ),
            // Create Event
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 2 ? _activeIcons[2] : _regularIcons[2], color: _currentIndex == 2 ? activeItemColor : itemColor),
              label: '',
            ),
            // 3: Bookmarks
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 3 ? _activeIcons[3] : _regularIcons[3], color: _currentIndex == 3 ? activeItemColor : itemColor),
              label: '',
            ),
            // 4: Profile
            BottomNavigationBarItem(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _currentIndex == 4 ? Border.all(color: activeItemColor, width: 2) : null,
                ),
                child: ClipOval(
                  child: Image.network(
                    finalProfilePictureUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: itemColor);
                    },
                  ),
                ),
              ),
              label: '',
            ),
          ],
        ),
      );
    });
  }
}
