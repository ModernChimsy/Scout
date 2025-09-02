class ApiUrl {
  static const String baseUrl = "https://api.scoutevents.co.za/api/v1";
  static const String socketGlobal = "https://renti-socket.techcrafters.tech";
  static String imageUrl({String? url}) {
    return "http://192.168.10.5:5005/$url";
  }

  static String socketURL = "http://115.127.156.14:5006";
  static const String signInEndPoint = "$baseUrl/users/create-customers";
  static const String login = "$baseUrl/auth/sign-in";
  static const String signUp = "$baseUrl/auth/sign-up";
  static const String forgetPass = "$baseUrl/auth/forget-password";
  static const String resetPassword = "$baseUrl/auth/reset-password";
  static const String otpVerify = "$baseUrl/auth/verify-account";
  static const String getProfile = "$baseUrl/user/profile";
  static const String updateProfile = "$baseUrl/user/profile";
  static const String changePassword = "$baseUrl/auth/change-password";
  static const String getAllEvent = "$baseUrl/event?limit=99999";
  static const String myInterestedEvent =
      "$baseUrl/event/my-interest-events?limit=99999";
  static const String myEvent = "$baseUrl/event/my-events?limit=99999";
  static const String todayEvent = "$baseUrl/event/today";
  static const String eventCreate = "$baseUrl/event/create";
  static const String getNotification = "$baseUrl/notification/notifications";
  static const String userList = "$baseUrl/user/nearby-users";
  static const String friendsEvent = "$baseUrl/event/friends-events";

  static String eventDetails({required String eventId}) =>
      "$baseUrl/event/$eventId";

  static String filterEvent(
          {required String tag,
          required String endDate,
          required String startDate}) =>
      "$baseUrl/event?startDate=$startDate&endDate=$endDate&tags=$tag&limit=99999";

  static String addEventInterested({required String eventId}) =>
      "$baseUrl/event/interest/$eventId";

  static String publicProfile({required String userID}) =>
      "$baseUrl/user/$userID";

  static String followUser({required String userID}) =>
      "$baseUrl/connection/follow-user/$userID";

  static String block({required String userID}) =>
      "$baseUrl/user/block/$userID";

  static String eventDelete({required String eventId}) =>
      "$baseUrl/event/$eventId";

  static String locationFilter({required dynamic lat, required dynamic long}) =>
      "$baseUrl/event/nearby-events?latitude=$lat&longitude=$long&distance=1000";
}
