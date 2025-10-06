// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/auth/token_manager.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/splash%20view/welcome_view.dart';

class SplashController extends GetxController {
  Timer? timer;
  var opacity = 0.0.obs;

  final TokenManager _tokenManager = TokenManager();

  @override
  void onInit() {
    super.onInit();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (opacity.value < 1.0) {
        opacity.value += 0.5;
      } else {
        t.cancel();
      }
    });

    Future.delayed(const Duration(seconds: 3), () async {
      String? accessToken = await _tokenManager.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        Get.offAll(() => BottomNavBarExample());
      } else {
        Get.offAll(() => const WelcomeView());
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
