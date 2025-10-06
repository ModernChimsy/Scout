import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../model/all_event_model.dart';

class AllEventController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var nurseData = AllEventModel().obs;

  @override
  void onInit() {
    super.onInit();
    getEvent();
  }

  getEvent() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(await BaseClient.getRequest(api: ApiUrl.getAllEvent));
      log.d("🧩 Get All Events Response Body: $responseBody");

      if (responseBody != null) {
        nurseData.value = AllEventModel.fromJson(responseBody);
      } else {
        throw 'Failed to fetch cart data!';
      }
    } catch (e) {
      log.e("🧩 Error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
