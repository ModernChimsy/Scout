// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/splash%20view/welcome_view.dart';

class SplashController extends GetxController {
  Timer? timer;
  var opacity = 0.0.obs;
  final StorageService _storageService = Get.put(StorageService());

  @override
  void onInit() {
    super.onInit();

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      if (opacity.value != 1.0) {
        opacity.value += 0.5;
      }
    });

    // After 3 seconds, check for accessToken and navigate
    Future.delayed(const Duration(seconds: 3), () async {
      String? accessToken = _storageService.read<String>('accessToken');

      if (accessToken != null && accessToken.isNotEmpty) {
        Get.to(() => BottomNavBarExample());
      } else {
        // If no accessToken exists, navigate to Welcome View
        Get.to(() => WelcomeView());
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
