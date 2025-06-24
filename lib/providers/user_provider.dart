import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user.dart';
import '../mock_server/hive_boxes.dart';

class UserProvider extends ChangeNotifier {
  Box<User>? _userBox;
  List<User> _users = [];

  List<User> get users => _users;

  UserProvider() {
    _init();
  }

  Future<void> _init() async {
    _userBox = await Hive.openBox<User>(HiveBoxes.userBox);
    _users = _userBox!.values.toList();
    notifyListeners();
  }

  User? getById(int key) {
    if (_userBox == null) return null;
    return _userBox!.get(key);
  }

  Future<int> addUser(User user) async {
    if (_userBox == null) return -1;
    final key = await _userBox!.add(user);
    _users = _userBox!.values.toList();
    notifyListeners();
    return key;
  }
}
