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

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: ApiUrl.filterEvent(tag: tag, endDate: endDate, startDate: startDate, query: query),
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
