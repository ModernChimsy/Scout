import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/uitilies/api/local_storage.dart';

class BaseClient {
  static final log = Logger();
  static var noInternetMessage = "Please check your connection!";

  static getRequest({required String api, params}) async {
    log.i("ℹ️ Get Request");

    /// get x storage
    final StorageService _storageService = Get.put(StorageService());
    String? accessToken = _storageService.read<String>('accessToken');

    var headers = {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };

    http.Response response = await http.get(
      Uri.parse(api).replace(queryParameters: params),
      headers: headers,
    );

    log.d("🧩 Request API Url: $api");
    log.d("🧩 Request params: $params");
    log.d("🧩 Request accessToken: $accessToken");
    log.d("🧩 Request Headers: $headers");
    log.d("🧩 Request Response: $response");

    return response;
  }

  static postRequest({required String api, body}) async {
    log.i("ℹ️ Post Request");

    /// getx storage
    final StorageService _storageService = Get.put(StorageService());
    String? accessToken = _storageService.read<String>('accessToken');

    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $accessToken"
    };

    http.Response response = await http.post(Uri.parse(api),
        body: body, headers: headers, encoding: Encoding.getByName("utf-8"));

    log.d("🧩 Request API Url: $api");
    log.d("🧩 Request Body: ${jsonEncode(body)}");
    log.d("🧩 Request accessToken: $accessToken");
    log.d("🧩 Request Headers: $headers");
    log.d("🧩 Request Response: $response");
    return response;
  }

  static deleteRequest({required String api, body}) async {
    log.i("ℹ️ Delete Request");

    /// getx storage
    final StorageService _storageService = Get.put(StorageService());
    String? accessToken = _storageService.read<String>('accessToken');

    var headers = {
      'Accept': 'application/json',
      "Authorization": "Bearer $accessToken"
    };

    http.Response response =
        await http.delete(Uri.parse(api), body: body, headers: headers);

    log.d("🧩 Request API Url: $api");
    log.d("🧩 Request Body: ${jsonEncode(body)}");
    log.d("🧩 Request accessToken: $accessToken");
    log.d("🧩 Request Headers: $headers");
    log.d("🧩 Request Response: $response");

    return response;
  }

  // Add PATCH method here
  static patchRequest({required String api, required Map<String, dynamic> body}) async {
    log.i("ℹ️ Patch Request");

    /// getx storage
    final StorageService _storageService = Get.put(StorageService());
    String? accessToken = _storageService.read<String>('accessToken');

    var headers = {
      'Content-type': 'application/json',
      "Authorization": "Bearer $accessToken"
    };

    try {
      http.Response response = await http.patch(
        Uri.parse(api),
        body: jsonEncode(body),
        headers: headers,
      );

      log.d("🧩 Request API Url: $api");
      log.d("🧩 Request Body: ${jsonEncode(body)}");
      log.d("🧩 Request accessToken: $accessToken");
      log.d("🧩 Request Headers: $headers");
      log.d("🧩 Request Response: $response");

      return response;
    } on SocketException {
      throw noInternetMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  static multipartAddRequest({
    required String api,
    required Map<String, String> body,
    required String fileKeyName,
    required String filePath,
  }) async {
    log.i("ℹ️ Multipart Add Request");

    var headers = {'Accept': 'application/json', "id": ""};

    http.MultipartRequest request;
    if (filePath.isEmpty || filePath == '') {
      request = http.MultipartRequest('POST', Uri.parse(api))
        ..fields.addAll(body)
        ..headers.addAll(headers);
    } else {
      request = http.MultipartRequest('POST', Uri.parse(api))
        ..fields.addAll(body)
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(fileKeyName, filePath));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log.d("🧩 Request API Url: $api");
    log.d("🧩 Request Body: ${jsonEncode(body)}");
    // log.d("🧩 Request accessToken: $accessToken");
    log.d("🧩 Request Headers: $headers");
    log.d("🧩 Request Response: $response");
    return response;
  }

  static handleResponse(http.Response response) async {
    log.i("ℹ️ Handling Response");
    log.d("🧩 Request Response: $response");

    try {
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        log.d('🧩 SuccessCode: ${response.statusCode}');
        log.d('🧩 SuccessResponse: ${response.body}');

        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 500) {
        log.e("❌ statusCode: 500");
        throw "Server Error";
      } else {
        log.e('❌ ErrorCode: ${response.statusCode}');
        log.e('❌ ErrorResponse: ${response.body}');

        String msg = "Something went wrong";
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body)['errors'];
          if (data == null) {
            msg = jsonDecode(response.body)['message'] ?? msg;
          } else if (data is String) {
            msg = data;
          } else if (data is Map) {
            msg = data['email'][0];
          }
        }

        throw msg;
      }
    } on SocketException catch (_) {
      throw noInternetMessage;
    } on FormatException catch (_) {
      throw "Bad response format";
    } catch (e) {
      throw e.toString();
    }
  }
}
