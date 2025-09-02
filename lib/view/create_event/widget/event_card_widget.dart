// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class EventCardWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? bgColor;
  final Color? textColor;

  const EventCardWidget(
      {super.key,
      required this.onTap,
      required this.title,
      this.bgColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: bgColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontWeight: FontWeight.w400,
              fontSize: 17,
              color: textColor!,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
