import 'package:get/get.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';
import '../event_details_model/event_details_model.dart';

class EventDetailsController extends GetxController {
  var isLoading = false.obs;
  var nurseData = EventDetailsModel().obs;

  @override
  void onInit() {
    super.onInit();
    getEventDetails();
  }

  getEventDetails({dynamic eventId}) async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(api: ApiUrl.eventDetails(eventId: eventId)),
      );

      if (responseBody != null) {
        nurseData.value = EventDetailsModel.fromJson(responseBody);
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
