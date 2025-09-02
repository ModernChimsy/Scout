import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class ActivitiesRowWidget extends StatelessWidget {
  final String artistName;
  final String time;
  final Color color;

  const ActivitiesRowWidget(
      {super.key, required this.artistName, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: artistName,
              fontSize: 14.sp,
              color: color,
            ),
            CustomText(
              text: time,
              fontSize: 14.sp,
              color: color,
            ),
          ],
        ));
  }
}
