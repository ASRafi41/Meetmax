// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostAdapter extends TypeAdapter<Post> {
  @override
  final int typeId = 1;

  @override
  Post read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Post(
      userId: fields[0] as int,
      time: fields[1] as DateTime,
      likeCount: fields[2] as int,
      commentCount: fields[3] as int,
      shareCount: fields[4] as int,
      content: fields[5] as String?,
      imageUrls: (fields[6] as List?)?.cast<String>(),
      likedUserIds: (fields[7] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.likeCount)
      ..writeByte(3)
      ..write(obj.commentCount)
      ..writeByte(4)
      ..write(obj.shareCount)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.imageUrls)
      ..writeByte(7)
      ..write(obj.likedUserIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
