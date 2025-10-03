import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool showObscure;
  final bool? readOnly;
  final IconData? prefixIcon;
  final String? image;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? hintTextColo;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.showObscure,
    this.keyboardType,
    this.controller,
    this.prefixIcon,
    this.fillColor,
    this.borderColor,
    this.maxLines,
    this.readOnly,
    this.image,
    this.iconColor,
    this.hintTextColo,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget? customSuffixIcon;

    if (widget.showObscure) {
      customSuffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.prefixIcon != null) {
      customSuffixIcon = Icon(widget.prefixIcon, color: widget.iconColor ?? Colors.grey);
    } else if (widget.image != null) {
      customSuffixIcon = Padding(
        padding: EdgeInsets.all(10.sp),
        child: Image.asset(widget.image!, width: 24.w, color: widget.iconColor, height: 24.h),
      );
    }

    return Container(
      width: Get.width,
      child: TextFormField(
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        readOnly: widget.readOnly ?? false,
        obscureText: widget.showObscure ? _obscureText : false,
        maxLines: widget.maxLines ?? 1,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.sp),
            borderSide: BorderSide(color: widget.borderColor ?? AppColors.mainColor, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.sp),
            borderSide: BorderSide(color: widget.borderColor ?? AppColors.mainColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.sp),
            borderSide: BorderSide(color: widget.borderColor ?? AppColors.mainColor, width: 1),
          ),
          /**
           * Only show the prefix icon if the customSuffixIcon is not set,
           * to prevent double icons if the intent was to move it.
           * Since the search screen specifically passed prefixIcon for the search icon,
           * we are intentionally making this null for those cases and handling it in suffixIcon.
           */
          prefixIcon: (widget.prefixIcon != null || widget.image != null) && !widget.showObscure
              ? null
              : widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: widget.iconColor ?? Colors.grey)
              : widget.image != null
              ? Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Image.asset(widget.image!, width: 24.w, color: widget.iconColor, height: 24.h),
                )
              : null,
          suffixIcon: customSuffixIcon,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14.h, color: widget.hintTextColo ?? Colors.grey),
        ),
      ),
    );
  }
}
