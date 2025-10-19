import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';

class FilterController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var filterResults = FilterModel().obs;

  Future<void> filterEvents({String tag = "", String endDate = "", String startDate = "", String? query}) async {
    try {
      isLoading(true);

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

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: ApiUrl.filterEvent(page: 1, tag: effectiveTag, endDate: endDate, startDate: startDate, query: effectiveQuery),
        ),
      );

      log.d("🧩 Get Filter Events Response Body: $responseBody");

      if (responseBody != null) {
        filterResults.value = FilterModel.fromJson(responseBody);
      } else {
        throw 'Failed to fetch filtered events!';
      }
    } catch (e) {
      log.e("🧩 Error occurred during event filter/search: $e");
    } finally {
      isLoading(false);
    }
  }
}
