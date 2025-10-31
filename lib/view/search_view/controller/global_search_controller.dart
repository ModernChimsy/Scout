// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/view/search_view/model/global_search_model.dart';
import 'package:restaurent_discount_app/view/search_view/model/user_search_model.dart';
import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';

class GlobalSearchController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var eventResults = <FilterData>[].obs;
  var userResults = <UserSearchData>[].obs;

  String get baseUrl => ApiUrl.baseUrl.endsWith('/') ? ApiUrl.baseUrl.substring(0, ApiUrl.baseUrl.length - 1) : ApiUrl.baseUrl;

  Future<void> searchAll({String tag = "", String endDate = "", String startDate = "", String? query, int page = 1}) async {
    try {
      isLoading(true);
      eventResults.clear();
      userResults.clear();

      String? effectiveQuery = query;
      String effectiveTag = tag;

      if (effectiveTag.isNotEmpty) {
        effectiveQuery = effectiveTag.replaceAll(',', ' ');
        effectiveTag = "";
      } else if (query != null && query.isNotEmpty) {
        effectiveQuery = query;
      }

      if (effectiveTag.isEmpty) {
        effectiveTag = "";
      }

      final String apiUrl = "$baseUrl/search?page=$page&limit=10&startDate=$startDate&endDate=$endDate&tag=$effectiveTag&query=${effectiveQuery ?? ''}";

      log.d("🧩 Calling Global Search API: $apiUrl");

      dynamic responseBody = await BaseClient.handleResponse(await BaseClient.getRequest(api: apiUrl));

      log.d("🧩 Global Search Response Body: $responseBody");

      if (responseBody != null && responseBody['data'] != null) {
        final results = GlobalSearchResult.fromJson(responseBody['data']);
        eventResults.value = results.events;
        userResults.value = results.users;
      } else {
        throw 'Failed to fetch search results!';
      }
    } catch (e) {
      log.e("🧩 Error during global search: $e");
      eventResults.clear();
      userResults.clear();
    } finally {
      isLoading(false);
    }
  }
}
