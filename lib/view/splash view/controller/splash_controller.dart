// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/auth/token_manager.dart'; // ❗️ ADD: Import for secure storage
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/splash%20view/welcome_view.dart';

class SplashController extends GetxController {
  Timer? timer;
  var opacity = 0.0.obs;

  // Keep your existing storage service
  final StorageService _storageService = Get.put(StorageService());
  // ❗️ ADD: Instantiate the new TokenManager for secure tokens
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

    // After 3 seconds, check for accessToken from EITHER storage and navigate
    Future.delayed(const Duration(seconds: 3), () async {
      // ❗️ MODIFIED: Check both storage locations

      // 1. Check the original storage (for email/pass users)
      String? regularToken = _storageService.read<String>('accessToken');

      // 2. Check the secure storage (for Google users)
      String? secureToken = await _tokenManager.getAccessToken();

      // If EITHER token exists, the user is logged in
      if ((regularToken != null && regularToken.isNotEmpty) ||
          (secureToken != null && secureToken.isNotEmpty)) {
        Get.offAll(() => BottomNavBarExample());
      } else {
        // If no accessToken exists in either storage, navigate to Welcome View
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
