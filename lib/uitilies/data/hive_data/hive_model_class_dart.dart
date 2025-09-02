import 'package:hive/hive.dart';

part 'hive_model_class_dart.g.dart';

@HiveType(typeId: 1)  // Make sure to use a unique typeId for this model
class EventCardModel extends HiveObject {
  @HiveField(0)
  final String eventId;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final String eventName;

  @HiveField(3)
  final String eventDate;

  @HiveField(4)
  final List<String> categories;

  @HiveField(5)
  final String eventDescription;

  @HiveField(6)
  final int friendsInterested;

  @HiveField(7)
  final List<dynamic> interestedPeopleImage;

  // Constructor
  EventCardModel({
    required this.eventId,
    required this.image,
    required this.eventName,
    required this.eventDate,
    required this.categories,
    required this.eventDescription,
    required this.friendsInterested,
    required this.interestedPeopleImage,
  });
}
