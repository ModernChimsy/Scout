import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../near_by_event_view.dart';

class LocationFilterController extends GetxController {
  var isLoading = false.obs;
  var nurseData = FilterModel().obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  getLocation({dynamic lat, dynamic long}) async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
            api: ApiUrl.locationFilter(lat: lat, long: long)),
      );

      if (responseBody != null) {
        nurseData.value = FilterModel.fromJson(responseBody);

        Get.to(() => NearByLocationView(
          selectedLat: lat,
          selectedLong: long,
        ));
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
