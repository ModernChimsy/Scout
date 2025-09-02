import 'package:get/get.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../model/my_interest_event_model.dart';

class MyInterstedController extends GetxController {
  var isLoading = false.obs;
  var nurseData = MyInterstedModel().obs;

  @override
  void onInit() {
    super.onInit();
    getInterestedEvent();
  }

  getInterestedEvent() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.myInterestedEvent),
      );

      if (responseBody != null) {
        nurseData.value = MyInterstedModel.fromJson(responseBody);
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
