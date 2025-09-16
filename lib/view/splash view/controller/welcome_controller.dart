import 'package:get/get.dart';
import 'package:restaurent_discount_app/auth/auth_manager.dart';
import 'package:logger/logger.dart';


class WelcomeController extends GetxController {
  final AuthManager _authManager = AuthManager();
  final log = Logger();

  var isLoading = false.obs;

  void handleGoogleSignIn() async {
    log.i("ℹ️ WelcomeController: SocialAuth");

    try {
      isLoading.value = true;
      await _authManager.signInWithGoogle();
    } finally {
      isLoading.value = false;
    }
  }
}
