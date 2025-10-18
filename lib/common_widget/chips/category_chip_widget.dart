// lib/common_widget/chips/category_chip_widget.dart

import 'package:flutter/material.dart';
import 'package:restaurent_discount_app/common%20widget/custom%20text/custom_text_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';

class CategoryChipWidget extends StatelessWidget {
  final String category;
  final bool isDarkMode;

  const CategoryChipWidget({super.key, required this.category, required this.isDarkMode});

  Color _categoryTextColor() {
    return isDarkMode ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.getCategoryBgColor(category), borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: CustomText(text: category, fontSize: 13, fontWeight: FontWeight.w500, color: _categoryTextColor()),
    );
  }
}
