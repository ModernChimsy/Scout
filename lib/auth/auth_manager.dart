// lib/auth/auth_manager.dart
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // ❗️ FIX: Added to resolve UI-related errors
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/auth/token_manager.dart';
// ❗️ FIX: Point to your actual home and welcome views
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/splash%20view/welcome_view.dart';

class AuthManager {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TokenManager _tokenManager = TokenManager();

  // --- CONFIGURATION ---
  // ❗️ Replace with your Node.js backend IP address and port
  static const String _apiBaseUrl = "http://192.168.10.156:5005";

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("Google sign-in was canceled by the user.");
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        print("Failed to get Firebase ID token.");
        return false;
      }
      return await _verifyTokenWithBackend(idToken);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Authentication Error', 'Firebase error: ${e.message}',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      Get.snackbar('Authentication Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.BOTTOM);
      print("Google Sign-In Error: $e");
      return false;
    }
  }

  Future<bool> _verifyTokenWithBackend(String idToken) async {
    final url = Uri.parse('$_apiBaseUrl/api/v1/social/verify');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'token': idToken}),
      );
      if (response.statusCode == 200) {
        print('Token verified by backend successfully.');
        final responseData = json.decode(response.body)['data'];
        final String accessToken = responseData['accessToken'];
        final String refreshToken = responseData['refreshToken'];
        await _tokenManager.saveTokens(
            accessToken: accessToken, refreshToken: refreshToken);

        // ❗️ FIX: Navigate to your actual home screen
        Get.offAll(() => BottomNavBarExample());
        return true;
      } else {
        final error = json.decode(response.body)['message'] ?? 'Unknown error';
        print('Failed to verify token with backend: ${response.body}');
        Get.snackbar('Login Failed', 'Server error: $error',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      print('Error sending token to backend: $e');
      Get.snackbar('Login Failed',
          'Could not connect to the server. Please check your network connection.',
          snackPosition: SnackPosition.BOTTOM);
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
