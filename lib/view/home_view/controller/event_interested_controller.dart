import 'dart:convert';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/uitilies/custom_toast.dart';

class InterestedPostController extends GetxController {
  static final log = Logger();

  var isLoading = false.obs;
  var message = ''.obs;

  Future<void> addToInterest({required String eventId}) async {
    isLoading(true);
    message.value = '';

    try {
      var response = await BaseClient.postRequest(api: ApiUrl.addEventInterested(eventId: eventId));

      if (response.statusCode == 200) {
        CustomToast.showToast("Event Added Successfully in Interest", isError: false);
      } else {
        var responseBody = json.decode(response.body);
        message.value = responseBody['message'];
        throw 'Failed to add product to cart: ${response.body}';
      }
    } catch (e) {
      log.e("🧩 Error occurred while adding product to cart: $e");

      if (e is String) {
        CustomToast.showToast(message.value.isNotEmpty ? message.value : "Something went wrong", isError: true);
      } else {
        CustomToast.showToast('An unexpected error occurred', isError: true);
      }
    } finally {
      isLoading(false);
    }
  }
}
