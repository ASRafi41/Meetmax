import 'package:hive/hive.dart';
import '../models/user.dart';
import '../models/post.dart';
import '../models/story.dart';

class HiveBoxes {
  static const String userBox = 'users';
  static const String postBox = 'posts';
  static const String storyBox = 'stories';
  static const String sessionBox = 'session';
}