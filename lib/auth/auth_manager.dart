import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/auth/token_manager.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/splash%20view/welcome_view.dart';

class AuthManager {
  final log = Logger();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final TokenManager _tokenManager = TokenManager();

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? googleIdToken = googleAuth.idToken;

      if (googleIdToken == null) {
        log.w("💣 Google User idToken was null. Cannot authenticate.");
        return false;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(idToken: googleIdToken);
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken();

      if (idToken == null) {
        log.w("💣 Failed to get Firebase ID token.");
        return false;
      }
      return await _verifyTokenWithBackend(idToken);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Authentication Error', 'Firebase error, Try Again Later', snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      log.d("🧩 Google Sign-In Error: $e");
      Get.snackbar('Authentication Error', 'An unexpected error occurred. Contact Admin', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<bool> _verifyTokenWithBackend(String idToken) async {
    log.d("🧩 VerifyTokenWithBackend idToken: $idToken");

    final url = Uri.parse(ApiUrl.socialVerify);
    try {
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({'token': idToken}));

      if (response.statusCode == 200) {
        log.d("🧩 Token verified by backend successfully.");

        final responseData = json.decode(response.body)['data'];
        final String accessToken = responseData['accessToken'];
        final String refreshToken = responseData['refreshToken'];
        await _tokenManager.saveTokens(accessToken: accessToken, refreshToken: refreshToken);

        Get.offAll(() => const BottomNavBarExample());
        return true;
      } else {
        final error = json.decode(response.body)['message'] ?? 'Unknown error';
        log.d("🧩 Failed to verify token with backend: ${response.body}");
        Get.snackbar('Login Failed', 'Try Again Later', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      log.d(" 🧩Error sending token to backend: $e");
      Get.snackbar('Login Failed', 'Could not connect to the server. Please check your network connection.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    await _tokenManager.clearTokens();
    Get.offAll(() => const WelcomeView());
  }
}
