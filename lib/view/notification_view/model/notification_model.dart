class NotificationModel {
  NotificationModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final NotificationModelData? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null
          ? null
          : NotificationModelData.fromJson(json["data"]),
    );
  }
}

class NotificationModelData {
  NotificationModelData({
    required this.meta,
    required this.data,
  });

  final Meta? meta;
  final List<Data> data;

  factory NotificationModelData.fromJson(Map<String, dynamic> json) {
    return NotificationModelData(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null
          ? []
          : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
    );
  }
}

class Data {
  Data({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.data,
    required this.link,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? body;
  final DatumData? data;
  final dynamic link;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      body: json["body"],
      data: json["data"] == null ? null : DatumData.fromJson(json["data"]),
      link: json["link"],
      isRead: json["isRead"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }
}

class DatumData {
  DatumData({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.image,
    required this.imagePath,
    required this.date,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.address,
    required this.tags,
    required this.ageRestriction,
    required this.isPublic,
    required this.isAgeRestricted,
    required this.isCoatCheckRequired,
    required this.isOwnAlcoholAllowed,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  final String? id;
  final String? userId;
  final String? title;
  final String? content;
  final String? image;
  final String? imagePath;
  final DateTime? date;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final Location? location;
  final String? address;
  final List<String> tags;
  final int? ageRestriction;
  final bool? isPublic;
  final bool? isAgeRestricted;
  final bool? isCoatCheckRequired;
  final bool? isOwnAlcoholAllowed;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final User? user;

  factory DatumData.fromJson(Map<String, dynamic> json) {
    return DatumData(
      id: json["id"],
      userId: json["userId"],
      title: json["title"],
      content: json["content"],
      image: json["image"],
      imagePath: json["imagePath"],
      date: DateTime.tryParse(json["date"] ?? ""),
      endDate: DateTime.tryParse(json["endDate"] ?? ""),
      startTime: json["startTime"],
      endTime: json["endTime"],
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      address: json["address"],
      tags: json["tags"] == null
          ? []
          : List<String>.from(json["tags"]!.map((x) => x)),
      ageRestriction: json["ageRestriction"],
      isPublic: json["isPublic"],
      isAgeRestricted: json["isAgeRestricted"],
      isCoatCheckRequired: json["isCoatCheckRequired"],
      isOwnAlcoholAllowed: json["isOwnAlcoholAllowed"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }
}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null
          ? []
          : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }
}

class User {
  User({
    required this.id,
    required this.fullname,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  final String? id;
  final String? fullname;
  final String? firstName;
  final String? lastName;
  final dynamic profilePicture;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      fullname: json["fullname"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      profilePicture: json["profilePicture"],
    );
  }
}

class Meta {
  Meta({
    required this.total,
    required this.page,
    required this.limit,
  });

  final int? total;
  final int? page;
  final int? limit;

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json["total"],
      page: json["page"],
      limit: json["limit"],
    );
  }
}
