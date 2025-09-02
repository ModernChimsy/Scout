import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/app_images.dart';
import 'package:restaurent_discount_app/view/splash%20view/controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Color(0xFFFB6012),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 230.h),
            Image.asset(
              "assets/images/white_logo.png",
              width: 195.w,
            ),
            Spacer(),
            LoadingAnimationWidget.beat(
              color: Colors.white,
              size: 38.h,
            ),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
