import 'dart:convert';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import '../../../../uitilies/custom_toast.dart';

class ConnectWithUserController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;

  Future<void> connect({required String userId}) async {
    isLoading(true);
    message.value = '';

    try {
      var response = await BaseClient.postRequest(
        api: ApiUrl.followUser(userID: userId),
      );

      if (response.statusCode == 200) {
      } else {
        var responseBody = json.decode(response.body);
        message.value = responseBody['message'];
        throw 'Failed to add product to cart: ${response.body}';
      }
    } catch (e) {
      print("Error occurred while adding product to cart: $e");

      if (e is String) {
        CustomToast.showToast(
            message.value.isNotEmpty ? message.value : "Something went wrong",
            isError: true);
      } else {
        CustomToast.showToast('An unexpected error occurred', isError: true);
      }
    } finally {
      isLoading(false);
    }
  }
}
