class UserSearchData {
  final String id;
  final String? fullname;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final String? username;

  UserSearchData({
    required this.id,
    this.fullname,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.username,
  });

  factory UserSearchData.fromJson(Map<String, dynamic> json) {
    return UserSearchData(
      id: json["id"],
      fullname: json["fullname"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      profilePicture: json["profilePicture"] ?? 'https://d29ragbbx3hr1.cloudfront.net/placeholder_profile.png',
      username: json["username"],
    );
  }
}
