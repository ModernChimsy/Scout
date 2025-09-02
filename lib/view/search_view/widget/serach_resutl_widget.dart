// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class SerachResutlWidget extends StatelessWidget {
  final Color color;

  const SerachResutlWidget({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Image.asset(
            "assets/images/event1.png",
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              color: color,
              text: "Fri, 3 Nov",
            ),
            CustomText(
              color: color,
              fontWeight: FontWeight.bold,
              text: "Timo ODV - Live at Halo",
            )
          ],
        )
      ],
    );
  }
}
