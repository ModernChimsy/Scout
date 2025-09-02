import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class CustomText extends StatelessWidget {
  CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color = Colors.black,
    this.text = "",
    this.overflow = TextOverflow.fade,
    this.letterSpace,
    this.italic,
    this.decoration, this.decorationColor,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final dynamic italic;
  final dynamic decoration;
  final TextAlign textAlign;
  final int? maxLines;
  final Color? decorationColor;
  final TextOverflow overflow;

  final dynamic letterSpace;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: GoogleFonts.poppins(
          decorationColor: decorationColor ?? AppColors.btnColor,
          decoration: decoration,
          letterSpacing: letterSpace,
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: italic,
          color: color,
        ),
      ),
    );
  }
}
