import 'package:hive/hive.dart';

part 'story.g.dart';

@HiveType(typeId: 2)
class Story extends HiveObject {
  @HiveField(0)
  int userId;

  @HiveField(1)
  String imageUrl;

  @HiveField(2)
  String text;

  Story({
    required this.userId,
    required this.imageUrl,
    required this.text,
  });
}
