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

  @HiveField(5)
  String? content;

  @HiveField(6)
  List<String>? imageUrls;

  @HiveField(7)
  List<int>? likedUserIds; // new: track which user keys have liked

  Post({
    required this.userId,
    required this.time,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.content,
    this.imageUrls,
    this.likedUserIds = const [],
  });
}
