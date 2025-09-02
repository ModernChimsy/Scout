class MyInterstedModel {
  MyInterstedModel({
     this.success,
     this.message,
     this.meta,
     this.data,
  });

  final bool? success;
  final String? message;
  final Meta? meta;
  final List<InterestData>? data;

  factory MyInterstedModel.fromJson(Map<String, dynamic> json){
    return MyInterstedModel(
      success: json["success"],
      message: json["message"],
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null ? [] : List<InterestData>.from(json["data"]!.map((x) => InterestData.fromJson(x))),
    );
  }

}

class InterestData {
  InterestData({
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

  factory InterestData.fromJson(Map<String, dynamic> json){
    return InterestData(
      id: json["id"],
      userId: json["userId"],
      eventId: json["eventId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      event: json["event"] == null ? null : Event.fromJson(json["event"]),
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
  final List<InterestEvent> interestEvents;
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
      interestEvents: json["interestEvents"] == null ? [] : List<InterestEvent>.from(json["interestEvents"]!.map((x) => InterestEvent.fromJson(x))),
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

class InterestEvent {
  InterestEvent({
    required this.user,
  });

  final User? user;

  factory InterestEvent.fromJson(Map<String, dynamic> json){
    return InterestEvent(
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

class Meta {
  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }

}
