// lib/common_widget/chips/category_more_chip_widget.dart

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class CategoryMoreChipWidget extends StatelessWidget {
  final int remainingCount;
  final bool isDarkMode;
  final VoidCallback onTap;

  const CategoryMoreChipWidget({super.key, required this.remainingCount, required this.isDarkMode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: AppColors.getCategoryMoreColor(), borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: CustomText(text: '+ $remainingCount more', fontSize: 13, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}
