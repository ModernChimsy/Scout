import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/view/search_view/model/user_search_model.dart';

class UserSearchCard extends StatelessWidget {
  static final log = Logger();

  final UserSearchData user;
  final bool isDarkMode;

  const UserSearchCard({super.key, required this.user, required this.isDarkMode});

  void _navigateToProfile() {
    // TODO: Replace with your actual User Profile Page navigation
    // Example: Get.to(() => UserProfilePage(userId: user.id));
    log.i("Navigate to user profile for ${user.id}");
  }

  @override
  Widget build(BuildContext context) {
    final displayUsername = (user.username?.isNotEmpty ?? false) ? user.username! : (user.firstName ?? 'scout_user');
    final displayName = user.fullname ?? 'Scout User';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0), // Gap between cards
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardBackgroundDark : AppColors.unselectedLightCardBg,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _navigateToProfile,
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(user.profilePicture ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png'),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _navigateToProfile,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(text: displayUsername, color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                  if (displayName.isNotEmpty) CustomText(text: displayName, color: Colors.grey, fontSize: 14),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              log.i("Follow button tapped for user ${user.id} ($displayUsername)");
              // TODO: Implement follow/unfollow logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? AppColors.defaultDark : AppColors.tabInActiveColorLight,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            ),
            child: Text(
              "Follow",
              style: TextStyle(color: isDarkMode ? Colors.white : AppColors.scoutVividVermilion, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
