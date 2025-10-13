// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common widget/custom text/custom_text_widget.dart';
import 'package:restaurent_discount_app/common widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';

class CategoriesFilterPage extends StatefulWidget {
  final Set<String> initialSelectedCategories;
  final Function(Set<String>) onCategoriesSelected;

  const CategoriesFilterPage({super.key, required this.onCategoriesSelected, required this.initialSelectedCategories});

  @override
  State<CategoriesFilterPage> createState() => _CategoriesFilterPageState();
}

class _CategoriesFilterPageState extends State<CategoriesFilterPage> {
  late Set<String> _selectedCategories;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final List<String> allCategories = [
    'Festival',
    'Food',
    'Wine',
    'Sports',
    'Literature',
    'Concerts',
    'Nightlife',
    'Tech',
    'Music',
    'Art',
    'Fundraising',
    'Outdoor',
  ];

  late List<String> filteredCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.initialSelectedCategories);
    filteredCategories = allCategories;

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        filteredCategories = allCategories;
      } else {
        filteredCategories = allCategories.where((category) => category.toLowerCase().contains(_searchQuery)).toList();
      }
    });
  }

  void _toggleCategory(String category) {
    final lowerCaseCategory = category.toLowerCase();
    setState(() {
      if (_selectedCategories.contains(lowerCaseCategory)) {
        _selectedCategories.remove(lowerCaseCategory);
      } else {
        _selectedCategories.add(lowerCaseCategory);
      }
    });
  }

  void _removeSelectedTag(String category) {
    setState(() {
      _selectedCategories.remove(category);
    });
  }

  void _applyFilter() {
    widget.onCategoriesSelected(_selectedCategories);
    Get.back();
  }

  void _cancel() {
    Get.back();
  }

  Widget _buildCategoryChip(String category, Color textColor, Color borderColor) {
    final lowerCaseCategory = category.toLowerCase();
    final isSelected = _selectedCategories.contains(lowerCaseCategory);

    if (isSelected) {
      return Chip(
        key: ValueKey(category),
        label: Text(category, style: TextStyle(color: Colors.white, fontSize: 14)),
        backgroundColor: AppColors.btnColor,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.btnColor),
        ),
        deleteIcon: Icon(Icons.close, color: Colors.white, size: 16),
        onDeleted: () => _removeSelectedTag(lowerCaseCategory),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }
    else {
      return ActionChip(
        key: ValueKey(category),
        label: Text(category, style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14)),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor),
        ),
        onPressed: () => _toggleCategory(category),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;
      Color textColor = isDarkMode ? Colors.white : Colors.black;
      Color borderColor = isDarkMode ? Colors.white54 : Colors.grey.shade400;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: 'Filter by category', fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
              SizedBox(height: 30),

              CustomTextField(
                controller: _searchController,
                prefixIcon: Icons.search,
                fillColor: isDarkMode ? Color(0xFF222222) : Colors.grey.shade100,
                borderColor: Colors.transparent,
                hintText: "Search",
                showObscure: false,
              ),
              SizedBox(height: 20),

              if (_searchQuery.isEmpty) CustomText(text: 'Search for tags to filter your results', fontSize: 14, color: textColor.withOpacity(0.6)),

              SizedBox(height: 10),

              if (_selectedCategories.isNotEmpty && _searchQuery.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _selectedCategories.map((tag) {
                      final displayTag = allCategories.firstWhere((c) => c.toLowerCase() == tag, orElse: () => tag.capitalizeFirst!);
                      return _buildCategoryChip(displayTag, textColor, borderColor);
                    }).toList(),
                  ),
                ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: filteredCategories.map((category) {
                        return _buildCategoryChip(category, textColor, borderColor);
                      }).toList(),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(
                  bgColor: AppColors.btnColor,
                  btnText: "Update filter",
                  onTap: _applyFilter,
                  iconWant: false,
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(
                  weight: FontWeight.w500,
                  bgColor: Colors.transparent,
                  btnText: "Cancel",
                  btnTextColor: textColor.withOpacity(0.8),
                  onTap: _cancel,
                  iconWant: false,
                ),
              ),
              SizedBox(height: 10.h + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      );
    });
  }
}
