import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/profile_view/settings_view/account_settings_view.dart';
import '../../../../../uitilies/api/local_storage.dart';
import '../../controller/profile_get_controller.dart';

class UpdateInterestController extends GetxController {
  var isLoading = false.obs;

  final ProfileGetController profileController =
      Get.put(ProfileGetController());

  Future<void> updateInterest({
    required List<String> interests,
  }) async {
    try {
      isLoading(true);

      var uri = Uri.parse(ApiUrl.updateProfile);
      final StorageService _storageService = StorageService();

      String? accessToken = _storageService.read<String>('accessToken');

      // Convert interests list to JSON
      var data = jsonEncode({
        'interest': interests,
      });

      var request = http.MultipartRequest('PATCH', uri)
        ..fields['data'] = data; // Adding the data to the request body

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
      }

      print("Request headers: ${request.headers}");
      print("Request body: $data");

      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(responseBody);

        if (responseJson['success'] == true) {
          CustomToast.showToast("Interest update successful!");

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
