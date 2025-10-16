import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:restaurent_discount_app/uitilies/app_colors.dart';
import 'package:restaurent_discount_app/uitilies/app_images.dart';
import 'package:restaurent_discount_app/view/splash%20view/controller/splash_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: AppColors.scoutVividVermilion,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 230.h),
            SvgPicture.asset("assets/icon/scout_logo_white.svg", width: 150.w),
            const Spacer(),
            LoadingAnimationWidget.beat(color: Colors.white, size: 38.h),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
