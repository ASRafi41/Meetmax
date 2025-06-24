import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/comment.dart';
import '../mock_server/hive_boxes.dart';

class CommentProvider extends ChangeNotifier {
  Box<Comment>? _commentBox;
  List<Comment> _comments = [];

  List<Comment> get comments => _comments;

  CommentProvider() {
    _init();
  }

  Future<void> _init() async {
    _commentBox = await Hive.openBox<Comment>(HiveBoxes.commentBox);
    _reloadComments();
  }

  void _reloadComments() {
    if (_commentBox == null) return;
    _comments = _commentBox!.values.toList()
      ..sort((a, b) => a.time.compareTo(b.time));
    notifyListeners();
  }

  Future<void> reload() async {
    if (_commentBox == null) {
      _commentBox = await Hive.openBox<Comment>(HiveBoxes.commentBox);
    }
    _reloadComments();
  }

  List<Comment> getByPostId(int postId) {
    return _comments.where((c) => c.postId == postId).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  Future<int> addComment(Comment comment) async {
    if (_commentBox == null) return -1;
    final key = await _commentBox!.add(comment);
    _reloadComments();
    return key;
  }
}
