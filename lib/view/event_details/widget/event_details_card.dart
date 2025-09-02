// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

import '../../../common widget/custom_elipse_text.dart';

class EventDetailsCard extends StatelessWidget {
  final String date;
  final String addresss;
  final Color color;

  const EventDetailsCard(
      {super.key,
      required this.color,
      required this.date,
      required this.addresss});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          color: color,
          text: "Event Details",
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: Colors.grey,
            ),
            SizedBox(width: 5.h),
            CustomText(
              color: color,
              text: date,
            )
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
            ),
            SizedBox(width: 5.h),
            CustomText(
              color: color,
              text: customEllipsisText(addresss,wordLimit: 4),
            )
          ],
        ),
      ],
    );
  }
}
