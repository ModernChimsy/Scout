// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/account_settings_view.dart';

import '../../../../../uitilies/api/local_storage.dart';

import 'dart:io';

import '../../controller/profile_get_controller.dart';

class UpdateProfileController extends GetxController {
  var isLoading = false.obs;

  final ProfileGetController profileController =
  Get.put(ProfileGetController());



  Future<void> updateProfile({
    required String firstName,
    required String userName,
    required String bio,
    File? profilePicture,
  }) async {
    try {
      isLoading(true);

      var uri = Uri.parse(ApiUrl.updateProfile);
      final StorageService _storageService = StorageService();

      String? accessToken = _storageService.read<String>('accessToken');

      var request = http.MultipartRequest('PATCH', uri);

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      if (profilePicture != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profilePicture',
          profilePicture.path,
          filename: profilePicture.path.split('/').last,
        ));
      }

      // Add fields
      request.fields
          .addAll({"firstName": firstName, "lastName": userName, "bio": bio});

      print("Request headers: ${request.headers}");
      print("Request fields: ${request.fields}");

      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(responseBody);

        if (responseJson['success'] == true) {
          CustomToast.showToast("Profile update successful!");




          profileController.getProfile();
          Get.to(() => AccountSettingsScreen());




        } else {
          String errorMessage =
              responseJson['message'] ?? 'Update failed. Please try again.';
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
