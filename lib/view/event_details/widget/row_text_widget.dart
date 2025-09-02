import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';

class RowTextWidget extends StatelessWidget {
  final String name;
  final Color color;
  final VoidCallback onTap;

  const RowTextWidget(
      {super.key,
      required this.name,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          color: color,
          text: name,
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        GestureDetector(
          onTap: onTap,
          child: CustomText(
            decoration: TextDecoration.underline,
            decorationColor: Colors.grey,
            text: 'See All',
            color: color,
            fontSize: 15.sp,
          ),
        )
      ],
    );
  }
}
