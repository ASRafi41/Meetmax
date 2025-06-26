import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/story.dart';
import '../mock_server/hive_boxes.dart';

class StoryProvider extends ChangeNotifier {
  Box<Story>? _storyBox;
  List<Story> _stories = [];

  List<Story> get stories => _stories;

  StoryProvider() {
    _init();
  }

  Future<void> _init() async {
    _storyBox = await Hive.openBox<Story>(HiveBoxes.storyBox);
    _stories = _storyBox!.values.toList();
    notifyListeners();
  }

  Future<void> reload() async {
    if (_storyBox == null) {
      _storyBox = await Hive.openBox<Story>(HiveBoxes.storyBox);
    }
    _stories = _storyBox!.values.toList();
    notifyListeners();
  }

  Future<int> addStory(Story story) async {
    if (_storyBox == null) return -1;
    final key = await _storyBox!.add(story);
    _stories = _storyBox!.values.toList();
    notifyListeners();
    return key;
  }
}