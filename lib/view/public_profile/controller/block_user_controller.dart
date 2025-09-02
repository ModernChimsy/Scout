import 'dart:convert';
import 'package:get/get.dart';
import 'package:restaurent_discount_app/common%20widget/successfull_page_for_all.dart';
import 'package:restaurent_discount_app/uitilies/api/base_client.dart';
import 'package:restaurent_discount_app/uitilies/api/api_url.dart';
import 'package:restaurent_discount_app/view/bottom_navigation_bar_view/bottom_navigation_bar_view.dart';
import '../../../../uitilies/custom_toast.dart';

class BlockUserController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;

  Future<void> block({required String userId}) async {
    isLoading(true);
    message.value = '';

    try {
      var response = await BaseClient.postRequest(
        api: ApiUrl.block(userID: userId),
      );

      if (response.statusCode == 200) {
        Get.offAll(() => SuccesfullyPageForAll(
              title: 'Success',
              subTitle: 'Successfully block the User',
              onTap: () {
                Get.offAll(() => BottomNavBarExample());
              },
            ));
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
