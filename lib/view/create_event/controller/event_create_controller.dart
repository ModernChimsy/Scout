// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/common%20widget/successfull_page_for_all.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/auth/token_manager.dart';

class EventCreateController extends GetxController {
  static final log = Logger();

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
      if (json != null && json['success'] == true) {
        CustomToast.showToast("Event created successfully!");

        final _storageService = Get.find<StorageService>();
        await _storageService.clearEventCreationData();

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
      log.e('❌ Error: $e');

      CustomToast.showToast(e.toString(), isError: true);
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> _executeAuthenticatedMultipartRequest({
    required String api,
    required Map<String, String> bodyFields,
    required File? file,
    required String fileKeyName,
  }) async {
    final uri = Uri.parse(api);

    final TokenManager _tokenManager = TokenManager();
    String? accessToken = await _tokenManager.getAccessToken();

    final request = http.MultipartRequest('POST', uri);

    if (accessToken != null && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      throw "Authentication token is missing. Please log in again.";
    }

    request.headers['Accept'] = 'application/json';
    request.fields.addAll(bodyFields);

    if (file != null && file.existsSync()) {
      request.files.add(await http.MultipartFile.fromPath(fileKeyName, file.path, filename: file.path.split('/').last));
    }

    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }
}
