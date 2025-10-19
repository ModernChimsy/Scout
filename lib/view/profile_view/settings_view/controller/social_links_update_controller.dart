// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/auth/token_manager.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/account_settings_view.dart';
import '../../controller/profile_get_controller.dart';

class UpdateSocialLinkController extends GetxController {
  var isLoading = false.obs;

  final ProfileGetController profileController = Get.put(ProfileGetController());

  Future<void> updateSocial(String instagram, String tiktok, String x, String spotify, String otherSocial) async {
    try {
      isLoading(true);

      var uri = Uri.parse(ApiUrl.updateProfile);

      final TokenManager _tokenManager = TokenManager();
      String? accessToken = await _tokenManager.getAccessToken();

      var request = http.MultipartRequest('PATCH', uri);

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      request.fields.addAll({"instagram": instagram, "tiktok": tiktok, "x": x, "spotify": spotify, "otherSocial": otherSocial});

      print("Request headers: ${request.headers}");
      print("Request fields: ${request.fields}");

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(responseBody);

        if (responseJson['success'] == true) {
          CustomToast.showToast("Social Links update successful!");
          profileController.getProfile();
          Get.to(() => AccountSettingsScreen());
        } else {
          String errorMessage = responseJson['message'] ?? 'Update failed. Please try again.';
          CustomToast.showToast(errorMessage, isError: true);
        }
      } else {
        throw 'Failed to update profile. Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Error during update: $e');
      CustomToast.showToast(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }
}
