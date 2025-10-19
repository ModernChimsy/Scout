import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/view/home_view/model/all_event_model.dart';

class AllEventController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var isPaginating = false.obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;

  var eventList = <AllEvent>[].obs;

  @override
  void onInit() {
    super.onInit();
    getInitialEvents();
  }

  Future<void> getInitialEvents() async {
    currentPage.value = 1;
    hasMore.value = true;
    eventList.clear();
    await fetchEvents();
  }

  Future<void> fetchEvents() async {
    if (isLoading.value || isPaginating.value || !hasMore.value) {
      log.d("🧩 Skipping fetch: Already loading or no more data.");
      return;
    }

    if (currentPage.value == 1) {
      isLoading(true);
    } else {
      isPaginating(true);
    }

    try {
      final api = ApiUrl.getAllEvent(page: currentPage.value);
      log.d("🧩 Fetching All Events from: $api");

      dynamic responseBody = await BaseClient.handleResponse(await BaseClient.getRequest(api: api));
      log.d("🧩 Get All Events Response Body Received");

      if (responseBody != null) {
        final allEventModel = AllEventModel.fromJson(responseBody);

        final newEvents = allEventModel.data ?? [];

        if (newEvents.isNotEmpty) {
          eventList.addAll(newEvents);
          currentPage.value++;
        }

        final meta = allEventModel.meta;

        if (meta != null && meta.totalPage != null) {
          hasMore.value = currentPage.value <= meta.totalPage!;
        } else {
          hasMore.value = newEvents.length == Constant.perPage;
        }
      } else {
        log.e('Failed to fetch events, response body is null.');
      }
    } catch (e) {
      log.e("🧩 Error occurred during event fetch: $e");
    } finally {
      isLoading(false);
      isPaginating(false);
    }
  }
}
