// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class SettingCard extends StatelessWidget {
  final String title;
  final String image;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final Color textColor;
  final Color? iconColor;
  final Color bgColor;

  const SettingCard({
    super.key,
    required this.title,
    this.icon,
    this.subtitle,
    required this.onTap,
    required this.image,
    required this.textColor,
    required this.bgColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    scale: 1,
                    color: iconColor,
                  ),
                  SizedBox(width: 10),
                  CustomText(
                    text: title,
                    fontSize: 16,
                    color: textColor,
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward_ios,
                size: 25,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
