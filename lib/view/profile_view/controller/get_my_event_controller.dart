import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/profile_view/model/my_saved_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';

class GetMyEventController extends GetxController {
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

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.myEvent),
      );

      if (responseBody != null) {
        nurseData.value = MyEventModel.fromJson(responseBody);
      } else {
        throw 'Failed to fetch cart data!';
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
