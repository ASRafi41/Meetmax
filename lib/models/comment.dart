import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 3)
class Comment extends HiveObject {
  @HiveField(0)
  int postId;

  @HiveField(1)
  int userId;

  @HiveField(2)
  String text;

  @HiveField(3)
  DateTime time;

  Comment({
    required this.postId,
    required this.userId,
    required this.text,
    required this.time,
  });
}
