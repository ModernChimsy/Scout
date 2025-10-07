// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/common%20widget/successfull_page_for_all.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/auth/token_manager.dart';

class EventCreateController extends GetxController {
  var isLoading = false.obs;

  Future<void> createEvent({
    required String title,
    required String content,
    required String date,
    required String endDate,
    required String startTime,
    required String endTime,
    required String ticketLink,
    required String address,
    required bool isPublic,
    required List<String> tags,
    required bool isAgeRestricted,
    required dynamic ageRestriction,
    required bool isCoatCheckRequired,
    required bool isOwnAlcoholAllowed,
    required List<Map<String, String>> activities,
    required List<String> ignoredUsers,
    required List<String> inviteUser,
    required dynamic latitude,
    required dynamic longitude,
    File? eventFile,
  }) async {
    try {
      isLoading(true);

      final Map<String, dynamic> rawBodyData = {
        "title": title,
        "content": content,
        "date": date,
        "endDate": endDate,
        "startTime": startTime,
        "endTime": endTime,
        "address": address,
        "isPublic": isPublic,
        "tags": tags,
        "ticketLink": ticketLink,
        "isAgeRestricted": isAgeRestricted,
        "ageRestriction": ageRestriction,
        "isCoatCheckRequired": isCoatCheckRequired,
        "isOwnAlcoholAllowed": isOwnAlcoholAllowed,
        "activities": activities,
        "ignoredUsers": ignoredUsers,
        "invitedUsers": inviteUser,
        "latitude": latitude,
        "longitude": longitude,
      };

      final Map<String, String> requestBody = {'data': jsonEncode(rawBodyData)};

      final http.Response response = await _executeAuthenticatedMultipartRequest(
        api: ApiUrl.eventCreate,
        bodyFields: requestBody,
        file: eventFile,
        fileKeyName: 'file',
      );

      dynamic json = await BaseClient.handleResponse(response);

      // --- 4. Process Success ---
      if (json != null && json['success'] == true) {
        CustomToast.showToast("🎉 Event created successfully!");

        Get.offAll(
          () => SuccesfullyPageForAll(
            title: "Event Created!",
            subTitle: "Your event is created successfully done.",
            onTap: () {
              Get.offAll(() => BottomNavBarExample());
            },
          ),
        );
      } else {
        throw json['message'] ?? 'Event creation failed with unknown error.';
      }
    } catch (e) {
      print('❌ Error: $e');
      CustomToast.showToast(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  /// Executes an authenticated multipart POST request.
  Future<http.Response> _executeAuthenticatedMultipartRequest({
    required String api,
    required Map<String, String> bodyFields,
    required File? file,
    required String fileKeyName,
  }) async {
    final uri = Uri.parse(api);

    // 🎯 FIX: Use TokenManager (or an equivalent structure) to get the token,
    // which aligns with BaseClient's methods. We initialize a static instance
    // here to match the TokenManager pattern often used in BaseClient.
    final TokenManager _tokenManager = TokenManager();
    String? accessToken = await _tokenManager.getAccessToken(); // 🎯 GET TOKEN CONSISTENTLY

    final request = http.MultipartRequest('POST', uri);

    // Set Authorization header for authentication
    if (accessToken != null && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      // Best practice: throw an error if the token is missing for a protected route
      throw "Authentication token is missing. Please log in again.";
    }

    // Set standard headers
    request.headers['Accept'] = 'application/json';

    // Add JSON data field
    request.fields.addAll(bodyFields);

    // Add optional file
    if (file != null && file.existsSync()) {
      request.files.add(await http.MultipartFile.fromPath(fileKeyName, file.path, filename: file.path.split('/').last));
    }

    // Send request and wait for stream conversion
    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }
}
