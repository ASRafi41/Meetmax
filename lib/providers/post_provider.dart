import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/post.dart';
import '../mock_server/hive_boxes.dart';

class PostProvider extends ChangeNotifier {
  Box<Post>? _postBox;
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  PostProvider() {
    _init();
  }

  Future<void> _init() async {
    _postBox = await Hive.openBox<Post>(HiveBoxes.postBox);
    _reloadPosts();
  }

  void _reloadPosts() {
    if (_postBox == null) return;
    _posts = _postBox!.values.toList()
      ..sort((a, b) => b.time.compareTo(a.time));
    notifyListeners();
  }

  Future<void> reload() async {
    _postBox ??= await Hive.openBox<Post>(HiveBoxes.postBox);
    _reloadPosts();
  }

  /// Internal method to add a post and return the key
  Future<int> addPost(Post post) async {
    if (_postBox == null) return -1;
    final key = await _postBox!.add(post);
    _reloadPosts();
    return key;
  }

  /// Public method for UI to create a new post
  Future<void> createPost(Post post) async {
    await addPost(post);
  }

  Future<void> likePost(int postKey, int userId) async {
    if (_postBox == null) return;
    final post = _postBox!.get(postKey);
    if (post == null) return;
    post.likedUserIds ??= [];
    if (!post.likedUserIds!.contains(userId)) {
      post.likedUserIds!.add(userId);
      post.likeCount = post.likedUserIds!.length;
      await post.save();
      _reloadPosts();
    }
  }

  Future<void> incrementCommentCount(int postKey) async {
    if (_postBox == null) return;
    final post = _postBox!.get(postKey);
    if (post != null) {
      post.commentCount += 1;
      await post.save();
      _reloadPosts();
    }
  }

  Future<void> deletePost(int postKey) async {
    if (_postBox == null) return;
    await _postBox!.delete(postKey);
    _reloadPosts();
  }
}
