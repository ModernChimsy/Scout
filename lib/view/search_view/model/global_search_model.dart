import 'package:restaurent_discount_app/view/search_view/model/filter_model.dart';
import 'package:restaurent_discount_app/view/search_view/model/user_search_model.dart';

class GlobalSearchResult {
  final List<UserSearchData> users;
  final List<FilterData> events;

  GlobalSearchResult({this.users = const [], this.events = const []});

  factory GlobalSearchResult.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResult(
      users: json['users'] != null
          ? List<UserSearchData>.from(
          json['users'].map((x) => UserSearchData.fromJson(x)))
          : [],
      events: json['events'] != null
          ? List<FilterData>.from(
          json['events'].map((x) => FilterData.fromJson(x)))
          : [],
    );
  }
}
