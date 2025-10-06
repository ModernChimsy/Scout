import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../near_by_event_view.dart';

class LocationFilterController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var nurseData = FilterModel().obs;
  var selectedLocationName = "Location".obs;

  getLocation({dynamic lat, dynamic long, String locationName = "Location"}) async {
    try {
      isLoading(true);
      selectedLocationName.value = locationName;

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: ApiUrl.locationFilter(lat: lat, long: long),
        ),
      );

      if (responseBody != null) {
        nurseData.value = FilterModel.fromJson(responseBody);

        Get.to(() => NearByLocationView(selectedLat: lat, selectedLong: long, locationName: locationName));
      } else {
        throw 'Failed to fetch cart data!';
      }
    } catch (e) {
      log.e("🧩 Error occurred:: $e");
    } finally {
      isLoading(false);
    }
  }

  void clearLocationFilter() {
    selectedLocationName.value = "Location";
  }
}
