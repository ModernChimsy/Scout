import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent_discount_app/auth/token_manager.dart';
import 'package:path_provider/path_provider.dart';

class BaseClient {
  static final log = Logger();
  static var noInternetMessage = "Please check your connection!";
  static const String _successLogFileName = 'success_api_responses.log';

  static final TokenManager _tokenManager = TokenManager();

  static Future<void> _logSuccessBodyToFile(String url, String method, String headers, String body) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_successLogFileName');

      final String timestamp = DateTime.now().toIso8601String();
      final String logEntry = "[$timestamp] \n---\nUrl:$url\nMethod:$method\nHeaders:\n$headers\nSuccess Body:\n$body\n===\n";

      await file.writeAsString(logEntry, mode: FileMode.append);

      log.i("🧩 Success Log written to file ➡️: ${file.path}");
    } catch (e) {
      log.e("Failed to write success log to file: $e");
    }
  }

  static Future<http.Response> getRequest({required String api, Map<String, dynamic>? params}) async {
    final String? accessToken = await _tokenManager.getAccessToken();
    final Map<String, String> headers = {'Content-type': 'application/json', "Authorization": "Bearer $accessToken"};
    final Uri uri = Uri.parse(api).replace(queryParameters: params?.map((key, value) => MapEntry(key, value.toString())));

    log.i("➡️ GET: $api");
    log.d({"url": uri.toString(), "headers": headers, "token_present": accessToken != null && accessToken.isNotEmpty});

    final http.Response response = await http.get(uri, headers: headers);
    log.i("⬅️ GET Response | Status: ${response.statusCode}");

    return response;
  }

  static Future<http.Response> postRequest({required String api, dynamic body}) async {
    final String? accessToken = await _tokenManager.getAccessToken();
    final Map<String, String> headers = {'Accept': 'application/json', "Authorization": "Bearer $accessToken"};
    final String bodyString = body is String ? body : jsonEncode(body);

    log.i("➡️ POST: $api");
    log.d({"url": api, "headers": headers, "body": bodyString, "token_present": accessToken != null && accessToken.isNotEmpty});

    final http.Response response = await http.post(Uri.parse(api), body: bodyString, headers: headers, encoding: Encoding.getByName("utf-8"));
    log.i("⬅️ POST Response | Status: ${response.statusCode}");

    return response;
  }

  static Future<http.Response> deleteRequest({required String api, dynamic body}) async {
    final String? accessToken = await _tokenManager.getAccessToken();
    final Map<String, String> headers = {'Accept': 'application/json', "Authorization": "Bearer $accessToken"};
    final String? bodyString = body != null ? (body is String ? body : jsonEncode(body)) : null;

    log.i("➡️ DELETE: $api");
    log.d({"url": api, "headers": headers, "body": bodyString, "token_present": accessToken != null && accessToken.isNotEmpty});

    final http.Response response = await http.delete(Uri.parse(api), body: bodyString, headers: headers);
    log.i("⬅️ DELETE Response | Status: ${response.statusCode}");

    return response;
  }

  static Future<http.Response> patchRequest({required String api, required Map<String, dynamic> body}) async {
    final String? accessToken = await _tokenManager.getAccessToken();
    final Map<String, String> headers = {'Content-type': 'application/json', "Authorization": "Bearer $accessToken"};
    final String bodyString = jsonEncode(body);

    log.i("➡️ PATCH: $api");
    log.d({"url": api, "headers": headers, "body": bodyString, "token_present": accessToken != null && accessToken.isNotEmpty});

    try {
      final http.Response response = await http.patch(Uri.parse(api), body: bodyString, headers: headers);
      log.i("⬅️ PATCH Response | Status: ${response.statusCode}");
      return response;
    } on SocketException {
      throw noInternetMessage;
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<http.Response> multipartAddRequest({
    required String api,
    required Map<String, String> body,
    required String fileKeyName,
    required String filePath,
  }) async {
    final Map<String, String> headers = {'Accept': 'application/json', "id": ""};

    log.i("➡️ MULTIPART POST: $api");
    log.d({"url": api, "headers": headers, "fields": body, "file_key": fileKeyName, "file_path": filePath.isEmpty ? 'N/A' : filePath});

    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(api))
      ..fields.addAll(body)
      ..headers.addAll(headers);

    if (filePath.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(fileKeyName, filePath));
    }

    final http.StreamedResponse streamedResponse = await request.send();
    final http.Response response = await http.Response.fromStream(streamedResponse);

    log.i("⬅️ MULTIPART Response | Status: ${response.statusCode}");

    return response;
  }

  static Future<dynamic> handleResponse(http.Response response) async {
    log.i("Processing Response: Status ${response.statusCode}");

    try {
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        await _logSuccessBodyToFile(
          response.request!.url.toString(),
          response.request!.method.toString(),
          response.request!.headers.toString(),
          response.body,
        );

        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          return response.body;
        }
      } else if (response.statusCode == 500) {
        log.e("❌ Server Error (500)");
        throw "Server Error";
      } else {
        log.e('❌ API Error | Status: ${response.statusCode} | Body: ${response.body}');

        String msg = "Something went wrong";
        if (response.body.isNotEmpty) {
          final decodedBody = jsonDecode(response.body);
          var data = decodedBody['errors'];

          if (data == null) {
            msg = decodedBody['message'] ?? msg;
          } else if (data is String) {
            msg = data;
          } else if (data is Map && data.containsKey('email') && data['email'] is List && data['email'].isNotEmpty) {
            msg = data['email'][0];
          } else if (decodedBody.containsKey('message')) {
            msg = decodedBody['message'];
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
