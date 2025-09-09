import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../uitilies/api/api_url.dart';
import '../../../uitilies/api/base_client.dart';
import '../model/profile_model.dart';

class ProfileGetController extends GetxController {

  final log = Logger();

  var isLoading = false.obs;
  var profile = ProfileModel().obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.getProfile),
      );

      if (responseBody['success'] == true) {
        profile.value = ProfileModel.fromJson(responseBody);
        log.d("🧩 Profile fetched: ${profile.value}");

      } else {
        throw 'Failed to load profile data: ${responseBody['message']}';
      }
    } catch (e) {
      log.e("❌ Error loading profile: $e");
    } finally {
      isLoading(false);
    }
  }
}
