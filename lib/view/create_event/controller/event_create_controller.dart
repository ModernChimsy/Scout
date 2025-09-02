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

      final uri = Uri.parse(ApiUrl.eventCreate);
      final storageService = StorageService();
      final accessToken = storageService.read<String>('accessToken');

      final request = http.MultipartRequest('POST', uri);

      if (accessToken != null && accessToken.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $accessToken';
        request.headers['Content-Type'] = 'multipart/form-data';
      }

      final Map<String, dynamic> bodyData = {
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

      request.fields['data'] = jsonEncode(bodyData);

      if (eventFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          eventFile.path,
          filename: eventFile.path.split('/').last,
        ));
      }

      print("🚀 Sending Request with fields: ${request.fields}");

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('✅ Response status: ${response.statusCode}');
      print('📦 Response body: $responseBody');

      final json = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (json['success'] == true) {
          CustomToast.showToast("🎉 Event created successfully!");

          Get.offAll(() => SuccesfullyPageForAll(
            title: "Event Created!",
            subTitle: "Your event is created successfully done.",
            onTap: () {
              Get.offAll(() => BottomNavBarExample());
            },
          ));
        } else {
          _handleError(json);
        }
      } else {
        _handleError(json);
      }
    } catch (e) {
      print('❌ Error: $e');
      CustomToast.showToast("Error: $e", isError: true);
    } finally {
      isLoading(false);
    }
  }

  void _handleError(Map<String, dynamic> json) {
    String errorMsg = json['message'] ?? "Something went wrong!";

    if (json['errorDetails']?['issues'] != null &&
        json['errorDetails']['issues'] is List) {
      final List issues = json['errorDetails']['issues'];
      if (issues.isNotEmpty) {
        errorMsg = issues.map((e) => e['message']).join('\n');
      }
    } else if (json['error']?['issues'] != null &&
        json['error']['issues'] is List) {
      final List issues = json['error']['issues'];
      if (issues.isNotEmpty) {
        errorMsg = issues.map((e) => e['message']).join('\n');
      }
    }

    CustomToast.showToast(errorMsg, isError: true);
  }
}
