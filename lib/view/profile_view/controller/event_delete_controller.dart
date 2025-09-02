// ignore_for_file: prefer_const_constructors

import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/successfull_page_for_all.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import 'package:restaurent_discount_app/view/profile_view/model/my_saved_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';

class EventDeleteController extends GetxController {
  var isLoading = false.obs;
  var nurseData = MyEventModel().obs;

  @override
  void onInit() {
    super.onInit();
    deleteEvent();
  }

  deleteEvent({dynamic eventId}) async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(
            api: ApiUrl.eventDelete(eventId: eventId)),
      );

      if (responseBody != null && responseBody['success'] == true) {
        Get.offAll(() => SuccesfullyPageForAll(
              title: "Event Deleted",
              subTitle: "Your Event was successfully deleted.",
              onTap: () {
                Get.off(() => BottomNavBarExample());
              },
            ));
      } else {
        throw 'Failed to delete event!';
      }
    } catch (e) {
      print("Error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
}
