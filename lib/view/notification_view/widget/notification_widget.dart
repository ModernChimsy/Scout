// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class NotificationItem extends StatelessWidget {
  final String profileImage;
  final String userName;
  final String message;
  final Color? titleColor;
  final Color? subtitleColor;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String? eventImage;

  const NotificationItem({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.message,
    this.actionText,
    this.onActionPressed,
    this.eventImage,
    this.titleColor,
    this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImage),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: subtitleColor, fontSize: 14),
                children: [
                  TextSpan(
                    text: "$userName ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: titleColor),
                  ),
                  TextSpan(text: message),
                ],
              ),
            ),
          ),
          if (actionText != null)
            ElevatedButton(
              onPressed: onActionPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnColor,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: CustomText(
                text: actionText!,
                color: subtitleColor!,
                fontSize: 12,
              ),
            ),
          if (eventImage != null) ...[
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                eventImage!,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
