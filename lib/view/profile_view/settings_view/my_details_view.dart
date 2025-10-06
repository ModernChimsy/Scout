// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurent_discount_app/common%20widget/custom_app_bar_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_button_widget.dart';
import 'package:restaurent_discount_app/common%20widget/custom_text_filed.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/custom_loader.dart';
import 'package:restaurent_discount_app/view/create_event/controller/theme_controller.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/controller/my_details_controller.dart';
import '../controller/profile_get_controller.dart';

class MyDetailsView extends StatefulWidget {
  const MyDetailsView({super.key});

  @override
  _MyDetailsViewState createState() => _MyDetailsViewState();
}

class _MyDetailsViewState extends State<MyDetailsView> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final ProfileGetController profileController =
      Get.put(ProfileGetController());
  final UpdateProfileController _updateProfileController =
      Get.put(UpdateProfileController());

  TextEditingController fullNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();


    // Initialize text controllers with existing profile data
    fullNameController.text =
        profileController.profile.value.data?.firstName ?? '';
    usernameController.text =
        profileController.profile.value.data?.lastName ?? '';
    bioController.text = profileController.profile.value.data?.bio ?? '';
    emailController.text = profileController.profile.value.data?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDarkMode = Get.find<ThemeController>().selectedTheme ==
          ThemeController.darkTheme;

      if (profileController.isLoading.value) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: CustomAppBar(title: "My Details"),
          body: Center(
            child: CircularProgressIndicator(), // Loading Indicator
          ),
        );
      }

      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: CustomAppBar(title: "My Details"),
        body: SingleChildScrollView(
          padding: AppPadding.bodyPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.btnColor.withOpacity(0.4),
                        backgroundImage: _imageFile != null
                            ? FileImage(File(_imageFile!.path))
                            : NetworkImage(profileController
                                        .profile.value.data?.profilePicture ??
                                    'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png')
                                as ImageProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: AppColors.btnColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Full Name",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: fullNameController,
                fillColor: Colors.transparent,
                borderColor: AppColors.btnColor,
                hintText: "Enter your full name",
                showObscure: false,
              ),
              SizedBox(height: 15),
              Text("Username",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: usernameController,
                fillColor: Colors.transparent,
                borderColor: AppColors.btnColor,
                hintText: "Enter your username",
                showObscure: false,
              ),
              SizedBox(height: 15),
              Text("Email",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              CustomTextField(
                readOnly: true,
                controller: emailController,
                fillColor: Colors.transparent,
                borderColor: AppColors.btnColor,
                hintText: "Enter your email account",
                showObscure: false,
              ),
              SizedBox(height: 15),
              Text("Bio",
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
              SizedBox(height: 6.h),
              CustomTextField(
                controller: bioController,
                maxLines: 5,
                fillColor: Colors.transparent,
                borderColor: AppColors.btnColor,
                hintText: "Enter your bio....",
                showObscure: false,
              ),
              SizedBox(height: 20),
              Obx(() {
                return _updateProfileController.isLoading.value == true
                    ? CustomLoader()
                    : CustomButtonWidget(
                        bgColor: AppColors.btnColor,
                        btnText: "Save",
                        onTap: () {
                          // Get text values from controllers
                          String firstName = fullNameController.text;
                          String userName = usernameController.text;
                          String bio = bioController.text;

                          // Check if an image is selected
                          File? profilePicture = _imageFile != null
                              ? File(_imageFile!.path)
                              : null;

                          // Call the updateProfile method
                          _updateProfileController.updateProfile(
                            firstName: firstName,
                            userName: userName,
                            bio: bio,
                            profilePicture: profilePicture,
                          );
                        },
                        iconWant: false,
                      );
              }),
              CustomButtonWidget(
                weight: FontWeight.w500,
                btnTextColor: isDarkMode ? Colors.white : Colors.black,
                bgColor: Colors.transparent,
                btnText: "Cancel",
                onTap: () {
                  Get.back();
                },
                iconWant: false,
              ),
              SizedBox(height: 26.h),
            ],
          ),
        ),
      );
    });
  }
}
