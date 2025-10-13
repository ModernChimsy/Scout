import 'package:restaurent_discount_app/uitilies/constant.dart';

class ApiUrl {
  static const String baseUrl = "https://api.scoutevents.co.za/api/v1";
  static const String socketGlobal = "https://renti-socket.techcrafters.tech";

  static String socketURL = "http://115.127.156.14:5006";
  static const String changePassword = "$baseUrl/auth/change-password";
  static const String forgetPass = "$baseUrl/auth/forget-password";
  static const String getProfile = "$baseUrl/user/profile";
  static const String login = "$baseUrl/auth/sign-in";
  static const String otpVerify = "$baseUrl/auth/verify-account";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  static const String signInEndPoint = "$baseUrl/users/create-customers";
  static const String signUp = "$baseUrl/auth/sign-up";
  static const String updateProfile = "$baseUrl/user/profile";

  static String getAllEvent({required int page, int limit = Constant.perPage}) => "$baseUrl/event?page=$page&limit=$limit";

  static String myInterestedEvent({required int page, int limit = Constant.perPage}) => "$baseUrl/event/my-interest-events?page=$page&limit=$limit";

  static String myEvent({required int page, int limit = Constant.perPage}) => "$baseUrl/event/my-events?page=$page&limit=$limit";

  static String todayEvent({required int page, int limit = Constant.perPage}) => "$baseUrl/event/today?page=$page&limit=$limit";

  static String friendsEvent({required int page, int limit = Constant.perPage}) => "$baseUrl/event/friends-events?page=$page&limit=$limit";

  static String eventDetails({required String eventId}) => "$baseUrl/event/$eventId";

  static const String getNotification = "$baseUrl/notification/notifications";
  static const String userList = "$baseUrl/user/nearby-users";
  static const String eventCreate = "$baseUrl/event/create";
  static const String socialVerify = "$baseUrl/social/verify";

  static String filterEvent({
    required int page,
    int limit = Constant.perPage,
    required String tag,
    required String endDate,
    required String startDate,
    String? query,
  }) {
    final Map<String, dynamic> params = {'page': page.toString(), 'limit': limit.toString(), 'startDate': startDate, 'endDate': endDate, 'tags': tag};

    if (query != null && query.isNotEmpty) {
      params['query'] = query;
    }

    final validParams = params.entries.where((e) => e.value != null && e.value.toString().isNotEmpty).map((e) => '${e.key}=${e.value}').join('&');

    return "$baseUrl/event?$validParams";
  }

  static String addEventInterested({required String eventId}) => "$baseUrl/event/interest/$eventId";

  static String publicProfile({required String userID}) => "$baseUrl/user/$userID";

  static String followUser({required String userID}) => "$baseUrl/connection/follow-user/$userID";

  static String block({required String userID}) => "$baseUrl/user/block/$userID";

  static String eventDelete({required String eventId}) => "$baseUrl/event/$eventId";

  static String locationFilter({required dynamic lat, required dynamic long}) => "$baseUrl/event/nearby-events?latitude=$lat&longitude=$long&distance=1000";
}
