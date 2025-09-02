// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class TopWidgetBookmarks extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color textColor;
  final IconData iconData;
  final VoidCallback onTap;

  const TopWidgetBookmarks(
      {super.key,
      required this.onTap,
      required this.title,
      required this.iconData,
      required this.bgColor,
      required this.textColor});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
              color: bgColor, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 21,
              ),
              SizedBox(width: 6),
              CustomText(
                color: textColor,
                text: title,
                fontSize: 14,
              ),
            ],
          )),
    );
  }
}
