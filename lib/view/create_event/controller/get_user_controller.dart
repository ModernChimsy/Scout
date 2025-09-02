import 'package:get/get.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../model/user_model.dart';

class GetUserController extends GetxController {
  var isLoading = false.obs;
  var nurseData = UserList().obs;

  @override
  void onInit() {
    super.onInit();
    getUser();
  }

  getUser() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.userList),
      );

      if (responseBody != null) {
        nurseData.value = UserList.fromJson(responseBody);
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
