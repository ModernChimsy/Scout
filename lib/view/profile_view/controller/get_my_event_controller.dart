import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/view/profile_view/model/my_saved_model.dart';
import 'package:restaurent_discount_app/uitilies/constant.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';

class GetMyEventController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var nurseData = MyEventModel().obs;

  @override
  void onInit() {
    super.onInit();
    getMyEvent();
  }

  getMyEvent() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(await BaseClient.getRequest(api: ApiUrl.myEvent(page: 1, limit: Constant.perPage)));

      if (responseBody != null) {
        nurseData.value = MyEventModel.fromJson(responseBody);
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
