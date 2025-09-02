import 'package:get/get.dart';
import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import '../../../../uitilies/api/api_url.dart';
import '../../../../uitilies/api/base_client.dart';

class FilterController extends GetxController {
  var isLoading = false.obs;
  var nurseData = FilterModel().obs;

  @override
  void onInit() {
    super.onInit();
    getFilter();
  }

  getFilter({dynamic tag, dynamic endDate, dynamic startDate}) async {
    try {
      isLoading(true);

      dynamic responseBody = await BaseClient.handleResponse(
        await BaseClient.getRequest(
            api: ApiUrl.filterEvent(
                tag: tag, endDate: endDate, startDate: startDate)),
      );

      if (responseBody != null) {
        nurseData.value = FilterModel.fromJson(responseBody);
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
