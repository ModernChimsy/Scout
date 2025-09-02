class UserList {
  UserList({
    this.success,
    this.message,
    this.data,
  });

  final bool? success;
  final String? message;
  final List<User>? data;

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? []
          : List<User>.from(json["data"]!.map((x) => User.fromJson(x))),
    );
  }
}

class User {
  User({
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    required this.fullname,
    required this.distance,
    required this.id,
  });

  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? fullname;
  final int? distance;
  final String? id;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profilePicture: json["profilePicture"],
      fullname: json["fullname"],
      distance: json["distance"],
      id: json["id"],
    );
  }
}
