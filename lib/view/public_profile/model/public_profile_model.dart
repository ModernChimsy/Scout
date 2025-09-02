class PublicProfileModel {
  PublicProfileModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory PublicProfileModel.fromJson(Map<String, dynamic> json){
    return PublicProfileModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.role,
    required this.bio,
    required this.instagram,
    required this.spotify,
    required this.x,
    required this.tiktok,
    required this.otherSocial,
    required this.firstName,
    required this.lastName,
    required this.fullname,
    required this.profilePicture,
    required this.interest,
    required this.isPrivate,
    required this.createdAt,
    required this.updatedAt,
    required this.followerCount,
    required this.followCount,
    required this.events,
    required this.interestEvents,
    required this.isFollowedByMe,
    required this.isBlockedByMe,
  });

  final String? id;
  final String? role;
  final String? bio;
  final String? instagram;
  final String? spotify;
  final String? x;
  final String? tiktok;
  final String? otherSocial;
  final String? firstName;
  final String? lastName;
  final String? fullname;
  final dynamic profilePicture;
  final List<String> interest;
  final bool? isPrivate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? followerCount;
  final int? followCount;
  final List<Event> events;
  final List<DataInterestEvent> interestEvents;
  final bool? isFollowedByMe;
  final bool? isBlockedByMe;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["id"],
      role: json["role"],
      bio: json["bio"],
      instagram: json["instagram"],
      spotify: json["spotify"],
      x: json["x"],
      tiktok: json["tiktok"],
      otherSocial: json["otherSocial"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      fullname: json["fullname"],
      profilePicture: json["profilePicture"],
      interest: json["interest"] == null ? [] : List<String>.from(json["interest"]!.map((x) => x)),
      isPrivate: json["isPrivate"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      followerCount: json["followerCount"],
      followCount: json["followCount"],
      events: json["events"] == null ? [] : List<Event>.from(json["events"]!.map((x) => Event.fromJson(x))),
      interestEvents: json["interestEvents"] == null ? [] : List<DataInterestEvent>.from(json["interestEvents"]!.map((x) => DataInterestEvent.fromJson(x))),
      isFollowedByMe: json["isFollowedByMe"],
      isBlockedByMe: json["isBlockedByMe"],
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
    required this.eventActivities,
    required this.interestEvents,
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
  final List<EventActivity> eventActivities;
  final List<EventInterestEvent> interestEvents;
  final User? user;

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
      eventActivities: json["eventActivities"] == null ? [] : List<EventActivity>.from(json["eventActivities"]!.map((x) => EventActivity.fromJson(x))),
      interestEvents: json["interestEvents"] == null ? [] : List<EventInterestEvent>.from(json["interestEvents"]!.map((x) => EventInterestEvent.fromJson(x))),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

}

class EventActivity {
  EventActivity({
    required this.id,
    required this.eventId,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final String? eventId;
  final String? name;
  final String? startTime;
  final String? endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory EventActivity.fromJson(Map<String, dynamic> json){
    return EventActivity(
      id: json["id"],
      eventId: json["eventId"],
      name: json["name"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class EventInterestEvent {
  EventInterestEvent({
    required this.user,
  });

  final User? user;

  factory EventInterestEvent.fromJson(Map<String, dynamic> json){
    return EventInterestEvent(
      user: json["user"] == null ? null : User.fromJson(json["user"]),
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

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"],
      fullname: json["fullname"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      profilePicture: json["profilePicture"],
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

class DataInterestEvent {
  DataInterestEvent({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.createdAt,
    required this.updatedAt,
    required this.event,
  });

  final String? id;
  final String? userId;
  final String? eventId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Event? event;

  factory DataInterestEvent.fromJson(Map<String, dynamic> json){
    return DataInterestEvent(
      id: json["id"],
      userId: json["userId"],
      eventId: json["eventId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      event: json["event"] == null ? null : Event.fromJson(json["event"]),
    );
  }

}
