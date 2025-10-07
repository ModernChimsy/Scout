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

class TicketsView extends StatefulWidget {
  const TicketsView({super.key});

  @override
  _TicketsViewState createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView> {
  final TextEditingController siteController = TextEditingController();
  final StorageService _storageService = StorageService();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadSavedSite();

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) {
          _saveAndExit();
        }
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    siteController.dispose();
    super.dispose();
  }

  void _loadSavedSite() async {
    String? savedSite = _storageService.read<String>('ticketSite');
    if (savedSite != null) {
      siteController.text = savedSite;
    }
  }

  Future<void> _saveAndExit() async {
    final site = siteController.text.trim();

    if (site.isEmpty) {
      CustomToast.showToast("Please enter a ticket website URL.", isError: true);
      return;
    }

    final uri = Uri.tryParse(site);

    if (uri == null || !uri.hasScheme) {
      CustomToast.showToast("Please enter a valid URL, including http:// or https://.", isError: true);
      return;
    }

    await _storageService.write('ticketSite', site);
    CustomToast.showToast("Ticket site saved.", isError: false);

    if (Get.isDialogOpen == false) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme == ThemeController.darkTheme;

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "Ticket Site"),
        body: Padding(
          padding: AppPadding.bodyPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Enter your ticket website",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: siteController,
                focusNode: _focusNode,
                keyboardType: TextInputType.url,
                fillColor: Colors.transparent,
                borderColor: Colors.grey,
                hintText: "Enter ticket website URL (e.g., https://scoutevents.co.za)",
                showObscure: false,
                onSubmitted: (_) => _saveAndExit(),
              ),
              SizedBox(height: 15),
              Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: CustomButtonWidget(bgColor: AppColors.btnColor, btnText: "Update", onTap: _saveAndExit, iconWant: false),
              ),
              SizedBox(height: 26.h),
            ],
          ),
        ),
      );
    });
  }
}
