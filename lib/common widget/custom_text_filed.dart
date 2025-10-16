import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool showObscure;
  final bool? readOnly;
  final IconData? trailingIcon;
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
  final FocusNode? focusNode;
  final String? initialValue;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.showObscure,
    this.keyboardType,
    this.controller,
    this.trailingIcon,
    this.fillColor,
    this.borderColor,
    this.maxLines,
    this.readOnly,
    this.image,
    this.iconColor,
    this.hintTextColo,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.initialValue,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Widget? customSuffixIcon;
    Widget? finalSuffixIcon;
    Widget? finalTrailingIcon;

    if (widget.showObscure) {
      final String assetPath = _obscureText ? 'assets/icon/eye_closed.svg' : 'assets/icon/eye_open.svg';

      customSuffixIcon = IconButton(
        icon: SvgPicture.asset(assetPath, colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn), width: 24.w, height: 24.h),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.showObscure) {
      finalSuffixIcon = customSuffixIcon;
      finalTrailingIcon = null;
    } else {
      if (widget.trailingIcon != null) {
        finalSuffixIcon = Icon(widget.trailingIcon, color: widget.iconColor ?? Colors.grey);
      } else if (widget.image != null) {
        finalSuffixIcon = Padding(
          padding: EdgeInsets.all(10.sp),
          child: Image.asset(widget.image!, width: 24.w, color: widget.iconColor, height: 24.h),
        );
      }
      finalTrailingIcon = null;
    }

    return Container(
      width: Get.width,
      child: TextFormField(
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
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
          prefixIcon: finalTrailingIcon,
          suffixIcon: finalSuffixIcon,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.poppins(fontSize: 14.h, color: widget.hintTextColo ?? Colors.grey),
        ),
      ),
    );
  }
}
