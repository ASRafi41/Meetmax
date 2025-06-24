import 'package:hive/hive.dart';
part 'post.g.dart';

@HiveType(typeId: 1)
class Post extends HiveObject {
  @HiveField(0)
  int userId;

  @HiveField(1)
  DateTime time;

  @HiveField(2)
  int likeCount;

  @HiveField(3)
  int commentCount;

  @HiveField(4)
  int shareCount;

  Post({
    required this.userId,
    required this.time,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
  });
}