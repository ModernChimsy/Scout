import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/public_profile/model/public_profile_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';

class PublicProfileController extends GetxController {
  var isLoading = false.obs;
  var nurseData = PublicProfileModel().obs;

  @override
  void onInit() {
    super.onInit();
    getPublicProfile();
  }

  getPublicProfile({dynamic userId}) async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.publicProfile(userID: userId)),
      );

      if (responseBody != null) {
        nurseData.value = PublicProfileModel.fromJson(responseBody);
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
