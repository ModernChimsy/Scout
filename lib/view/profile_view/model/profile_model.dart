class ProfileModel {
  ProfileModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ProfileModel.fromJson(Map<String, dynamic> json){
    return ProfileModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullname,
    required this.bio,
    required this.email,
    required this.role,
    required this.profilePicture,
    required this.instagram,
    required this.x,
    required this.isPrivate,
    required this.loginCount,
    required this.followerCount,
    required this.activeFollowerNotification,
    required this.activeEventNotification,
    required this.otherSocial,
    required this.spotify,
    required this.username,
    required this.isDelete,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.phoneNumber,
    required this.interest,
    required this.followCount,
    required this.followers,
    required this.following,
    required this.events,
    required this.interestEvents,
    required this.interestedEvents,
  });

  final String? id;
  final String? firstName;
  final String? lastName;
  final String? fullname;
  final dynamic bio;
  final String? email;
  final String? role;
  final dynamic profilePicture;
  final dynamic instagram;
  final dynamic x;
  final bool? isPrivate;
  final int? loginCount;
  final int? followerCount;
  final bool? activeFollowerNotification;
  final bool? activeEventNotification;
  final dynamic otherSocial;
  final dynamic spotify;
  final String? username;
  final bool? isDelete;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic phoneNumber;
  final List<String> interest;
  final int? followCount;
  final List<Follower> followers;
  final List<dynamic> following;
  final List<Event> events;
  final List<dynamic> interestEvents;
  final List<Event> interestedEvents;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      fullname: json["fullname"],
      bio: json["bio"],
      email: json["email"],
      role: json["role"],
      profilePicture: json["profilePicture"],
      instagram: json["instagram"],
      x: json["x"],
      isPrivate: json["isPrivate"],
      loginCount: json["loginCount"],
      followerCount: json["followerCount"],
      activeFollowerNotification: json["activeFollowerNotification"],
      activeEventNotification: json["activeEventNotification"],
      otherSocial: json["otherSocial"],
      spotify: json["spotify"],
      username: json["username"],
      isDelete: json["isDelete"],
      isActive: json["isActive"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      phoneNumber: json["phoneNumber"],
      interest: json["interest"] == null ? [] : List<String>.from(json["interest"]!.map((x) => x)),
      followCount: json["followCount"],
      followers: json["followers"] == null ? [] : List<Follower>.from(json["followers"]!.map((x) => Follower.fromJson(x))),
      following: json["following"] == null ? [] : List<dynamic>.from(json["following"]!.map((x) => x)),
      events: json["events"] == null ? [] : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      interestEvents: json["interestEvents"] == null ? [] : List<dynamic>.from(json["interestEvents"]!.map((x) => x)),
      interestedEvents: json["interestedEvents"] == null ? [] : List<Event>.from(json["interestedEvents"]!.map((x) => Event.fromJson(x))),
    );
  }

}

class Event {
  Event({
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

  factory Event.fromJson(Map<String, dynamic> json){
    return Event(
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
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      address: json["address"],
      tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
      ageRestriction: json["ageRestriction"],
      isPublic: json["isPublic"],
      isAgeRestricted: json["isAgeRestricted"],
      isCoatCheckRequired: json["isCoatCheckRequired"],
      isOwnAlcoholAllowed: json["isOwnAlcoholAllowed"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }

}

class Follower {
  Follower({
    required this.id,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? followerId;
  final String? followingId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Follower.fromJson(Map<String, dynamic> json){
    return Follower(
      id: json["id"],
      followerId: json["followerId"],
      followingId: json["followingId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}
