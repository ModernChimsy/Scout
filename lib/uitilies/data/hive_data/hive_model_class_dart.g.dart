// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model_class_dart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventCardModelAdapter extends TypeAdapter<EventCardModel> {
  @override
  final int typeId = 1;

  @override
  EventCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventCardModel(
      eventId: fields[0] as String,
      image: fields[1] as String,
      eventName: fields[2] as String,
      eventDate: fields[3] as String,
      categories: (fields[4] as List).cast<String>(),
      eventDescription: fields[5] as String,
      friendsInterested: fields[6] as int,
      interestedPeopleImage: (fields[7] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventCardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.eventName)
      ..writeByte(3)
      ..write(obj.eventDate)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.eventDescription)
      ..writeByte(6)
      ..write(obj.friendsInterested)
      ..writeByte(7)
      ..write(obj.interestedPeopleImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
