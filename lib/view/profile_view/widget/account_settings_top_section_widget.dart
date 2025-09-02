import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/profile_view/widget/shimmer_profile_widget.dart'; // Import the shimmer widget

class AccountSettingsProfileTopSection extends StatelessWidget {
  final String name;
  final String profileImage;
  final String username;
  final Color color;


  const AccountSettingsProfileTopSection({
    super.key,
    required this.name,
    required this.profileImage,
    required this.username,
    required this.color,

  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColors.btnColor, width: 2),
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: name,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                const SizedBox(height: 5),
                CustomText(
                  italic: FontStyle.italic,
                  text: username,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Share Feedback Section
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xFFFFF5F0),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(Icons.feedback_outlined, color: AppColors.btnColor),
              const SizedBox(width: 12),
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: "Share feedback\nHelp us improve your experience!",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
