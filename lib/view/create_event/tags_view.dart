// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'create_event_view.dart';

class TagsView extends StatefulWidget {
  const TagsView({super.key});

  @override
  _TagsViewState createState() => _TagsViewState();
}

class _TagsViewState extends State<TagsView> {
  final List<String> _interests = [
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

  List<String> _selectedInterests = [];
  final StorageService _storageService = StorageService();

  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedTags();

    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_searchFocusNode.hasFocus) {
      if (_selectedInterests.isNotEmpty) {
        Future.delayed(Duration(milliseconds: 100), () {
          if (mounted) {
            // Todo Implement search tags here
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadSavedTags() async {
    final savedTagsJson = _storageService.read<String>('selectedTags');
    if (savedTagsJson != null && savedTagsJson.isNotEmpty) {
      try {
        final List<String> decoded = savedTagsJson.split(',');
        setState(() {
          _selectedInterests = decoded.map((e) => e.trim()).toList();
        });
      } catch (e) {
        _storageService.remove('selectedTags');
      }
    }
  }

  void _toggleSelection(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  Future<void> _saveTagsAndExit() async {
    if (_selectedInterests.isEmpty) {
      CustomToast.showToast("Please select at least one tag", isError: true);
      return;
    }

    final tagsString = _selectedInterests.join(',');
    await _storageService.write('selectedTags', tagsString);
    CustomToast.showToast("Tag Saved", isError: false);

    Get.to(() => CreateEventView());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Tags"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Search",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                fillColor: Colors.transparent,
                borderColor: Colors.grey,
                hintText: "Search here.....",
                showObscure: false,
                prefixIcon: Icons.search,
                // onSubmitted: (_) => _saveTagsAndExit(), // TODO: add search logic here
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _interests.map((interest) {
                      bool isSelected = _selectedInterests.contains(interest);
                      return ChoiceChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (_) {
                          _toggleSelection(interest);
                          FocusScope.of(context).unfocus();
                        },
                        selectedColor: AppColors.btnColor,
                        backgroundColor: isDarkMode ? Color(0xFF4B515580) : Color(0xFFF4F4F4),
                        labelStyle: TextStyle(
                          color: isDarkMode ? (isSelected ? Colors.black : Colors.white) : (isSelected ? Colors.white : Colors.black),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                        side: BorderSide.none,
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Save", onTap: _saveTagsAndExit, iconWant: false),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(
                  weight: FontWeight.w500,
                  bgColor: Colors.transparent,
                  btnText: "Cancel",
                  btnTextColor: isDarkMode ? Colors.white : Colors.black,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  iconWant: false,
                ),
              ),
              SizedBox(height: 26.h),
            ],
          ),
        ),
      );
    });
  }
}
