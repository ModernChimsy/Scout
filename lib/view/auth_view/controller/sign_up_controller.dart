// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/view/auth_view/otp_cofirmation_view.dart';

import '../../../../../uitilies/api/local_storage.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required List<String> interests,
  }) async {
    try {
      isLoading(true);

      var uri = Uri.parse(ApiUrl.signUp);
      final StorageService _storageService = StorageService();

      var data = jsonEncode({
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'interest': interests,
      });

      var request = http.MultipartRequest('POST', uri)..fields['data'] = data;

      print("Request Body: ${request.fields}");

      var response = await request.send();

      String responseBody = await response.stream.bytesToString();

      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        var responseJson = jsonDecode(responseBody);

        if (responseJson['success'] == true) {
          String token = responseJson['data']['token'];
          await _storageService.write('token', token);

          CustomToast.showToast("Registration successful! Please enter OTP");
          Get.to(() => OTPConfirmationView(
                redirectFromView: true, email: email,
              ));
        } else {
          String errorMessage = responseJson['message'] ??
              'Registration failed. Please try again.';
          CustomToast.showToast(errorMessage, isError: true);
        }
      } else {
        var responseJson = jsonDecode(responseBody);
        String errorMessage = responseJson['error']?['message'] ??
            'Registration failed. Server error: ${response.statusCode}';
        throw errorMessage;
      }
    } catch (e) {
      print('Error during registration: $e');
      CustomToast.showToast(e.toString(),
          isError: true); // Show the error message to the user
    } finally {
      isLoading(false);
    }
  }
}
