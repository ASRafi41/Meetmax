// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 2;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      userId: fields[0] as int,
      imageUrl: fields[1] as String,
      text: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.text);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
